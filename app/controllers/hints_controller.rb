class HintsController < ApplicationController
  def create
    @game = Game.find_by!(token: params[:game_token])

    if @game.is_over? || @game.won? || @game.over?
      return render json: { error: "Game is over" }, status: :unprocessable_entity
    end

    if @game.hints_remaining <= 0
      return render json: { error: "No hints remaining" }, status: :unprocessable_entity
    end

    revealed_positions = @game.revealed_hints.map { |h| h["position"] }
    available_positions = (0...@game.code_length).to_a - revealed_positions

    if available_positions.empty?
      return render json: { error: "All positions already revealed" }, status: :unprocessable_entity
    end

    position = available_positions.sample
    digit    = @game.secret_code[position]
    hint     = { "position" => position, "digit" => digit }

    new_revealed = @game.revealed_hints + [hint]
    new_metadata = @game.metadata.merge("revealed_hints" => new_revealed)

    @game.update_columns(
      metadata: new_metadata,
      hints_used: @game.hints_used + 1
    )

    render json: {
      hint:            hint,
      hints_used:      @game.hints_used,
      hints_remaining: @game.hints_remaining,
      revealed_hints:  new_revealed
    }
  end
end
