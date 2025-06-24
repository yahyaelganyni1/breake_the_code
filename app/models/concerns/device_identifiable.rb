module DeviceIdentifiable
  extend ActiveSupport::Concern

  included do
    before_action :identify_user
  end

  private

  def identify_user
    device_id = cookies.permanent[:device_id] || generate_device_id
    cookies.permanent[:device_id] = device_id
    @current_user = User.find_or_create_by_device_id(device_id)
  end

  def generate_device_id
    # Combine user agent, IP address, and random string for uniqueness
    identifier = "#{request.user_agent}-#{request.remote_ip}-#{SecureRandom.hex(10)}"
    Digest::SHA256.hexdigest(identifier)
  end

  def current_user
    @current_user
  end
end
