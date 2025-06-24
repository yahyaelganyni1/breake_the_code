class GamesController < ApplicationController
  require 'browser'
  require 'geocoder'

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)

    if @game.save
      # Collect and save metadata
      browser = Browser.new(request.user_agent)
      ip = request.remote_ip
      location = Geocoder.search(ip).first
      referrer_url = request.referrer || "Direct visit"

      user_meta_data = {
        device: browser.device.name,
        platform: browser.platform.name,
        browser: browser.name,
        version: browser.version,
        name: browser.device.name,
        device_id: browser.device.id,
        ip: ip,
        country: location&.country,
        city: location&.city,
        referrer: referrer_url,
        current_url: request.original_url,
        user_agent: request.user_agent,
        method: request.method
      }

      # Save the metadata to the game
      @game.update_column(:metadata, user_meta_data)

      redirect_to game_path(@game)
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

  def meta_data
    browser = Browser.new(request.user_agent)
    ip = request.remote_ip
    location = Geocoder.search(ip).first

    # Get the referrer URL
    referrer_url = request.referrer || "Direct visit"

    user_meta_data = {
      device: browser.device.name,
      platform: browser.platform.name,
      browser: browser.name,
      version: browser.version,
      name: browser.device.name,
      device_id: browser.device.id,
      ip: ip,
      country: location&.country,
      city: location&.city,
      referrer: referrer_url, # Add the referrer URL here
      current_url: request.original_url, # You can also add the current URL
      user_agent: request.user_agent,
      method: request.method
    }

    p "User Meta Data: #{user_meta_data.inspect}"
  end
end
