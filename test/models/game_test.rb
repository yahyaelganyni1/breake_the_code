require "test_helper"

class GameTest < ActiveSupport::TestCase
  # Build a game with a controlled secret_code by stubbing the before_create hook.
  def build_game(difficulty: "normal", secret: nil, start_offset_seconds: 0, hints_used: 0)
    secret ||= default_secret_for(difficulty)
    game = Game.new(difficulty: difficulty, hints_used: hints_used)
    game.define_singleton_method(:generate_secret_code) { self.secret_code = secret }
    game.save!
    game.update_columns(start_time: start_offset_seconds.seconds.ago) if start_offset_seconds.positive?
    game
  end

  def default_secret_for(_difficulty)
    "1234"
  end

  def add_guess(game, code, feedback: nil)
    g = game.guesses.build(code: code)
    g.save!
    g.update_columns(feedback: feedback) if feedback
    g
  end

  test "loser scores zero regardless of attempts or time" do
    game = build_game(difficulty: "normal", start_offset_seconds: 30)
    game.max_attempts.times { add_guess(game, "9876") }
    game.check_game_over

    assert game.is_over?
    assert_not game.won?
    assert_equal 0, game.score
  end

  test "winner score uses base, attempts, time, hints, and difficulty multiplier" do
    game = build_game(difficulty: "normal", start_offset_seconds: 60, hints_used: 1)
    add_guess(game, "9876")
    add_guess(game, "8765")
    add_guess(game, "1234")
    game.check_game_over

    # raw = 1000 - (60 * 2) - (60 / 6) - 150 = 720
    # final = (720 * 1.5).round = 1080
    assert game.won?
    assert_equal 1080, game.score
  end

  test "first guess incurs no attempt penalty" do
    game = build_game(difficulty: "normal", start_offset_seconds: 0)
    add_guess(game, "1234")
    game.check_game_over

    assert_equal 0, game.score_breakdown[:attempt_penalty]
  end

  test "easy multiplier is 1.0 and hard is 2.5 on clean wins" do
    easy = build_game(difficulty: "easy", start_offset_seconds: 0)
    add_guess(easy, "1234")
    easy.check_game_over

    hard = build_game(difficulty: "hard", secret: "1234", start_offset_seconds: 0)
    add_guess(hard, "1234")
    hard.check_game_over

    assert_in_delta 1000, easy.score, 5
    assert_in_delta 2500, hard.score, 5
  end

  test "hint penalty applied to score when a hint was used" do
    game = build_game(difficulty: "normal", start_offset_seconds: 0, hints_used: 1)
    add_guess(game, "1234")
    game.check_game_over

    # raw = 1000 - 0 - 0 - 150 = 850; final = (850 * 1.5).round = 1275
    assert_equal 1275, game.score
  end

  test "difficulty drives code_length, digit_pool, and max_attempts" do
    easy = Game.new(difficulty: "easy")
    assert_equal 4, easy.code_length
    assert_equal (1..9).to_a, easy.digit_pool
    assert_equal 10, easy.max_attempts

    hard = Game.new(difficulty: "hard")
    assert_equal 4, hard.code_length
    assert_equal (0..9).to_a, hard.digit_pool
    assert_equal 8, hard.max_attempts
  end

  test "generated secret matches difficulty length, pool, and uniqueness" do
    [["easy", 4, 1, 9], ["normal", 4, 0, 9], ["hard", 4, 0, 9]].each do |diff, len, min_digit, max_digit|
      game = Game.create!(difficulty: diff)
      assert_equal len, game.secret_code.length, "#{diff}: wrong length"
      assert game.secret_code.chars.all? { |c| (min_digit..max_digit).cover?(c.to_i) }, "#{diff}: #{game.secret_code} out of pool"
      assert_equal len, game.secret_code.chars.uniq.length, "#{diff}: digits not unique"
    end
  end

  test "validates difficulty inclusion" do
    game = Game.new(difficulty: "extreme")
    assert_not game.valid?
    assert_not_empty game.errors[:difficulty]
  end

  test "achievements: quick clean win earns speed_demon, sharpshooter, pure_skill, flawless" do
    game = build_game(difficulty: "normal", start_offset_seconds: 5)
    add_guess(game, "9876", feedback: "1333")
    add_guess(game, "1234", feedback: "1111")
    game.check_game_over

    badges = game.achievements
    assert_includes badges, :speed_demon
    assert_includes badges, :sharpshooter
    assert_includes badges, :pure_skill
    assert_includes badges, :flawless
    assert_not_includes badges, :hard_mode
  end

  test "achievements: hard_mode awarded only on hard difficulty win" do
    game = build_game(difficulty: "hard", secret: "1234")
    add_guess(game, "1234")
    game.check_game_over
    assert_includes game.achievements, :hard_mode
  end

  test "achievements: flawless not awarded if any guess lacked a correct-position digit" do
    game = build_game(difficulty: "normal")
    add_guess(game, "9876", feedback: "2333")
    add_guess(game, "1234", feedback: "1111")
    game.check_game_over
    assert_not_includes game.achievements, :flawless
  end

  test "achievements: empty when game lost" do
    game = build_game(difficulty: "normal")
    game.max_attempts.times { add_guess(game, "9876") }
    game.check_game_over
    assert_equal [], game.achievements
  end

  test "top10 orders by score desc, then attempts asc, then end_time asc" do
    Game.destroy_all
    high  = create_finished_game(score: 1500, attempts: 5, end_time: 2.hours.ago, name: "High")
    mid_a = create_finished_game(score: 1000, attempts: 6, end_time: 1.hour.ago,  name: "Mid-A")
    mid_b = create_finished_game(score: 1000, attempts: 5, end_time: 30.minutes.ago, name: "Mid-B")
    mid_c = create_finished_game(score: 1000, attempts: 5, end_time: 10.minutes.ago, name: "Mid-C")

    assert_equal [high, mid_b, mid_c, mid_a], Game.top10.to_a
  end

  test "top10 excludes games without winner_name" do
    Game.destroy_all
    create_finished_game(score: 999, attempts: 3, end_time: 1.hour.ago, name: nil)
    visible = create_finished_game(score: 100, attempts: 3, end_time: 1.hour.ago, name: "Visible")
    assert_equal [visible], Game.top10.to_a
  end

  def create_finished_game(score:, attempts:, end_time:, name:)
    g = Game.create!(difficulty: "normal")
    g.update_columns(score: score, attempts: attempts, end_time: end_time, winner_name: name, is_over: true)
    g
  end
end
