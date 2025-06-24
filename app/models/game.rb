# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  attempts    :integer
#  end_time    :datetime
#  is_over     :boolean          default(FALSE)
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

  def generate_token
    self.token = SecureRandom.urlsafe_base64(8)
    p "token0000000 #{token}"
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
