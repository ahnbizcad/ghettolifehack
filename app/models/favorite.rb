# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  hack_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :hack

  validates_uniqueness_of :user_id, scope: [:hack_id]
  # If validation fails, delete

end
