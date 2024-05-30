class GuessesController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @guess = @game.guesses.build(guess_params)
    @is_over = @game.is_over

    if @game.over?
      @game.update(is_over: true)
      redirect_to game_path(@game), notice: "Game over! The secret code was #{@game.secret_code}"
    elsif @game.you_win?
        redirect_to game_path(@game), notice: "Congratulations! You've guessed the code!"
    else
      if @guess.save
        redirect_to game_path(@game)
      else
        render 'games/show'
      end
    end
  end

  private

  def guess_params
    params.require(:guess).permit(:code)
  end
end
