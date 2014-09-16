class Hack < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  acts_as_commentable

  scope :by_newest,         -> { order("created_at DESC") }
  #scope :by_highest_rating, -> { order("rating DESC") } # with vote table?
  #scope :by_lowest_rating,  -> { order("rating ASC") }  # with vote table?



end
