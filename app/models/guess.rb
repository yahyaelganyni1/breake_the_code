# == Schema Information
#
# Table name: guesses
#
#  id         :bigint           not null, primary key
#  code       :string
#  feedback   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_guesses_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#
class Guess < ApplicationRecord
  belongs_to :game
  before_save :generate_feedback

  private

  def generate_feedback
    guess_code = code.split('')
    secret_code = game.secret_code.split('')

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
    self.feedback = feedback.shuffle.join
  end
end
