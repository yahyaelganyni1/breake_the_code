class Guess < ApplicationRecord
  belongs_to :game
  before_save :generate_feedback

  private

  def generate_feedback
    guess_code = code.split('')
    secret_code = game.secret_code.split('')
    p "Guess code: A111#{guess_code}"
    p "Secret code: A111#{secret_code}"
    exact_matches = guess_code.each_with_index.count { |number, i| number == secret_code[i] }
    number_matches = (guess_code & secret_code).flat_map { |number| [guess_code.count(number), secret_code.count(number)].min }.sum - exact_matches
    p "Exact: #{exact_matches}, number only: #{number_matches}"
    self.feedback = "Exact: #{exact_matches}, number only: #{number_matches}"
    feedback = []
    guess_code.each_with_index do |number, i|
      if number == secret_code[i]
      # feedback << "Right number in the right place"
      feedback << "1"
      elsif secret_code.include?(number)
      # feedback << "Right number but in the wrong place"
      feedback << "2"
      else
      # feedback << "Wrong number"
      feedback << "3"
      end
    end
    self.feedback = feedback.join(", ")
  end
end
