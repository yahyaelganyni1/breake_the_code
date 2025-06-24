# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  attempts    :integer
#  end_time    :datetime
#  is_over     :boolean          default(FALSE)
#  metadata    :jsonb
#  secret_code :string
#  start_time  :datetime
#  token       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_games_on_token  (token) UNIQUE
#
require "test_helper"

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
