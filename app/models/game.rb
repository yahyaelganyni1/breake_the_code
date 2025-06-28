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
  # after_save :update_game_status
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

  private

  def update_game_status
    p "Updating game status for game #{id} - is_over: #{is_over}, over?: #{over?}, won?: #{won?}"
    # Skip this method if we're already processing an update to is_over
    # to prevent infinite callback loops
    return if saved_changes.key?('is_over') && is_over
    p "Game status update triggered0000 for game #{id}"
    p "0000over?: #{over?}, won?: #{won?}, guesses count: #{guesses.count}"
    if over? || won?
      # Combine both updates into one call
      update_columns(
        is_over: true,
        end_time: Time.current,
        attempts: guesses.count,
        score: calculate_score_value
      )
    end
  end

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
