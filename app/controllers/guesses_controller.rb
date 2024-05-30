class GuessesController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @guess = @game.guesses.build(guess_params)

    if @game.over?
      redirect_to game_path(@game), notice: "Game is over. Start a new game."
    elsif @guess.save
      if @guess.code == @game.secret_code
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
