# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  device_identifier :string
#  last_active       :datetime
#  nickname          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class User < ApplicationRecord
    has_many :games

  # def self.find_or_create_by_device_id(device_id)
  #   user = find_by(device_identifier: device_id)
  #   unless user
  #     user = create(device_identifier: device_id, last_active: Time.current)
  #   end
  #   user.update(last_active: Time.current)
  #   user
  # end
end
