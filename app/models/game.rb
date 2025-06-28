# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  attempts    :integer
#  end_time    :datetime
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
  belongs_to :user, optional: true
  has_many :guesses, dependent: :destroy
  before_create :generate_token
  before_create :generate_secret_code
  after_create :set_start_time

  scope :top10, -> {
    where.not(score: nil).order(score: :desc).limit(10)
  }
  # Ex:- scope :active, -> {where(:active => true)}
  # Initialize metadata as empty hash if nil
  def metadata
    self[:metadata] ||= {}
  end

  # Helper method to store metadata
  def set_metadata(key, value)
    self.metadata = metadata.merge(key.to_s => value)
    save
  end

  # Helper method to get metadata
  def get_metadata(key)
    metadata[key.to_s]
  end

  def to_param
    token
  end

  def over?
    guesses.count >= 10 && guesses.last.code != secret_code
  end

  def won?
    if guesses.last
      p "guesses.last:A #{guesses.last.code}"
      guesses.last.code == secret_code
    else
      false
    end
  end


    def check_game_over
      p 'checking if game is over0000'
      last_guess = guesses.last

      if last_guess.present?
        if last_guess.code == secret_code || guesses.count >= 10
            update_columns(
              is_over: true,
              end_time: Time.current,
              score: calculate_score_value,
              attempts: guesses.count
            )
        end
      end
    end

  private


  # Create a separate method for score calculation that doesn't depend on is_over field
  def calculate_score_value
    time_taken = Time.current - (start_time || created_at)
    base_score = 1000
    penalty_per_attempt = 50
    penalty_for_time = (time_taken / 60).to_i * 10

    score = base_score - (penalty_per_attempt * guesses.count) - penalty_for_time
    score.positive? ? score : 0
  end

  # Keep this method for external callers
  def calculate_score
    return 0 unless is_over
    calculate_score_value
  end

  def generate_token
    # debugger
    p 'token generated00'
    self.token = SecureRandom.urlsafe_base64(8)
  end


  def generate_secret_code
    numbers = (1..9).to_a.shuffle
    self.secret_code = 4.times.map { numbers.pop }.join
    p "secret_code: #{secret_code}"
  end

  def set_start_time
    update_column(:start_time, Time.current)
  end
end
