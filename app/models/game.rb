class Game < ApplicationRecord
  has_many :guesses, dependent: :destroy
  before_create :generate_secret_code

  def over?
    guesses.count >= 10 || guesses.any? { |guess| guess.code == secret_code }
  end

  private

  def generate_secret_code
    numbers = (1..9).to_a
    self.secret_code = 4.times.map { numbers.sample }.join
    p "Secret code: #{secret_code}"
  end
end
