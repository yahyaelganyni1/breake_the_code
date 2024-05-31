class GuessesController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @guess = @game.guesses.build(guess_params)

    if @game.over?
      redirect_to game_path(@game), notice: "Game over! The secret code was #{@game.secret_code}"
    elsif @guess.save
      if @game.won?
        redirect_to game_path(@game), notice: "Congratulations! You've guessed the code!"
      else
        redirect_to game_path(@game)
      end
    else
      render 'games/show'
    end
  end

  private

  def guess_params
    params.require(:guess).permit(:code)
  end
end
