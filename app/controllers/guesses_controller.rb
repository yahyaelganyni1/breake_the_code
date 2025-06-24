class GuessesController < ApplicationController
  def create
    @game = Game.find_by!(token: params[:game_token])
    @guess = @game.guesses.build(guess_params)

    if @guess.save
      redirect_to game_path(@game)
    else
      redirect_to game_path(@game), alert: 'There was a problem with your guess.'
    end
  end

  private

  def guess_params
    params.require(:guess).permit(:code)
  end
end
