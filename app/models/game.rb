# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  attempts    :integer
#  difficulty  :string           default("normal"), not null
#  end_time    :datetime
#  hints_used  :integer          default(0), not null
#  is_over     :boolean          default(FALSE)
#  metadata    :jsonb
#  score       :integer
#  secret_code :string
#  start_time  :datetime
#  token       :string
#  winner_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_games_on_token  (token) UNIQUE
#
class Game < ApplicationRecord
  DIFFICULTIES = {
    "easy"   => { code_length: 4, digit_pool: (1..9).to_a, max_attempts: 10, multiplier: 1.0 },
    "normal" => { code_length: 4, digit_pool: (0..9).to_a, max_attempts: 10, multiplier: 1.5 },
    "hard"   => { code_length: 4, digit_pool: (0..9).to_a, max_attempts: 8,  multiplier: 2.5 }
  }.freeze

  BASE_SCORE      = 1000
  ATTEMPT_PENALTY = 60
  HINT_PENALTY    = 150
  MAX_HINTS       = 2

  belongs_to :user, optional: true
  has_many :guesses, dependent: :destroy

  validates :difficulty, inclusion: { in: DIFFICULTIES.keys }

  before_create :generate_token
  before_create :generate_secret_code
  after_create  :set_start_time

  scope :top10, -> {
    where.not(score: nil)
      .where.not(winner_name: [nil, ""])
      .order(score: :desc, attempts: :asc, end_time: :asc)
      .limit(10)
  }

  def metadata
    self[:metadata] ||= {}
  end

  def set_metadata(key, value)
    self.metadata = metadata.merge(key.to_s => value)
    save
  end

  def get_metadata(key)
    metadata[key.to_s]
  end

  def to_param
    token
  end

  def code_length
    config[:code_length]
  end

  def digit_pool
    config[:digit_pool]
  end

  def max_attempts
    config[:max_attempts]
  end

  def difficulty_multiplier
    config[:multiplier]
  end

  def hints_remaining
    [MAX_HINTS - hints_used, 0].max
  end

  def revealed_hints
    metadata["revealed_hints"] || []
  end

  def over?
    is_over? || (guesses.count >= max_attempts && !won?)
  end

  def won?
    guesses.last&.code == secret_code
  end

  def check_game_over
    last_guess = guesses.last
    return unless last_guess.present?
    return unless last_guess.code == secret_code || guesses.count >= max_attempts

    update_columns(
      is_over: true,
      end_time: Time.current,
      score: calculate_score_value,
      attempts: guesses.count
    )
  end

  def achievements
    return [] unless won?

    badges = []
    badges << :speed_demon  if time_taken_seconds < 60
    badges << :sharpshooter if guesses.count <= 4
    badges << :pure_skill   if hints_used.zero?
    badges << :hard_mode    if difficulty == "hard"
    badges << :flawless     if guesses.any? && guesses.all? { |g| g.feedback.to_s.include?("1") }
    badges
  end

  def score_breakdown
    return { won: false, final: 0 } unless won?

    raw_attempt_penalty = ATTEMPT_PENALTY * [guesses.count - 1, 0].max
    raw_time_penalty    = (time_taken_seconds / 6.0).round
    raw_hint_penalty    = HINT_PENALTY * hints_used
    raw                 = BASE_SCORE - raw_attempt_penalty - raw_time_penalty - raw_hint_penalty
    final               = [(raw * difficulty_multiplier).round, 0].max

    {
      won:             true,
      base:            BASE_SCORE,
      attempt_penalty: raw_attempt_penalty,
      time_penalty:    raw_time_penalty,
      hint_penalty:    raw_hint_penalty,
      multiplier:      difficulty_multiplier,
      final:           final
    }
  end

  private

  def config
    DIFFICULTIES[difficulty] || DIFFICULTIES["normal"]
  end

  def time_taken_seconds
    end_at   = end_time || Time.current
    start_at = start_time || created_at || end_at
    (end_at - start_at).to_f
  end

  def calculate_score_value
    score_breakdown[:final]
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64(8)
  end

  def generate_secret_code
    pool = digit_pool.shuffle
    self.secret_code = code_length.times.map { pool.pop }.join
  end

  def set_start_time
    update_column(:start_time, Time.current)
  end
end
