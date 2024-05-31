class Game < ApplicationRecord
  has_many :guesses, dependent: :destroy
  before_create :generate_secret_code
  # attr_accessor :secret_code

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

  def generate_secret_code
    numbers = (1..9).to_a.shuffle
    self.secret_code = 4.times.map { numbers.pop }.join
    p "secret_code: #{secret_code}"
  end
end
