class Game < ApplicationRecord
  has_many :guesses, dependent: :destroy
  before_create :generate_secret_code

  def over?
    guesses.count >= 10 && guesses.last.code != secret_code
  end

  def won?
    guesses.last == secret_code && guesses.count <= 10
  end

  private

  def generate_secret_code
    numbers = (1..9).to_a.shuffle
    self.secret_code = 4.times.map { numbers.pop }.join
  end
end
