class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)

    if @game.save
      p "Game created with token: #{@game.token}"
      redirect_to game_path(@game)
      # debugger
    else
      p "Game failed to save: #{@game.errors.full_messages.join(', ')}"
      render :new
    end
  end

  def show
    @game = Game.find_by!(token: params[:token])  # Change this line to use token
    @guess = Guess.new
  end

  private  # Add this line

  def game_params
    params.fetch(:game, {}).permit(:user_id)  # Add any other permitted parameters
  end

  def set_game
    @game = Game.find_by!(token: params[:token])
  end
end
