require "test_helper"

class HintsControllerTest < ActionDispatch::IntegrationTest
  def make_game(difficulty: "normal", secret: "1234")
    game = Game.new(difficulty: difficulty)
    game.define_singleton_method(:generate_secret_code) { self.secret_code = secret }
    game.save!
    game
  end

  test "create reveals a digit and increments hints_used" do
    game = make_game

    post game_hints_url(game), headers: { "Accept" => "application/json" }
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal 1, body["hints_used"]
    assert_equal Game::MAX_HINTS - 1, body["hints_remaining"]
    assert_equal game.secret_code[body["hint"]["position"]], body["hint"]["digit"]

    game.reload
    assert_equal 1, game.hints_used
    assert_equal 1, game.revealed_hints.length
  end

  test "create rejects when no hints remaining" do
    game = make_game
    game.update_columns(hints_used: Game::MAX_HINTS)

    post game_hints_url(game), headers: { "Accept" => "application/json" }
    assert_response :unprocessable_entity

    body = JSON.parse(response.body)
    assert_match(/no hints remaining/i, body["error"])
  end

  test "create rejects when game is already over" do
    game = make_game
    game.update_columns(is_over: true)

    post game_hints_url(game), headers: { "Accept" => "application/json" }
    assert_response :unprocessable_entity
  end

end
