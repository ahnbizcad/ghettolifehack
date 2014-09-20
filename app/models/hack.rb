# == Schema Information
#
# Table name: hacks
#
#  id                    :integer          not null, primary key
#  created_at            :datetime
#  updated_at            :datetime
#  body                  :text
#  user_id               :integer
#  comment_threads_count :integer          default(0), not null
#
# Indexes
#
#  index_hacks_on_user_id  (user_id)
#

class Hack < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  acts_as_commentable
  acts_as_votable

  scope :by_newest,         -> { order("created_at DESC") }
  #scope :by_highest_rating, -> { order("rating DESC") } # with vote table?
  #scope :by_lowest_rating,  -> { order("rating ASC") }  # with vote table?

  def image
    self.user.image
  end

end
