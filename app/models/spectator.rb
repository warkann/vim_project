# == Schema Information
#
# Table name: spectators
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  s_model     :string(255)
#  s_action    :string(255)
#  s_record_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Spectator < ActiveRecord::Base
end
