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
#  cached_tag_list       :string(255)
#
# Indexes
#
#  index_hacks_on_user_id  (user_id)
#

class Hack < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  
  has_many :favoriters, through: :favorites, source: :users
  has_many :favorites, dependent: :destroy

  acts_as_commentable
  acts_as_taggable_on :tags
  acts_as_votable

  #def self.eager_loaded_except_comments
  #  all.eager_load([:favorites, :users])
  #end

  scope :by_newest,         -> { order("hacks.created_at DESC") }
  #scope :by_highest_rating, -> { order("rating DESC") } # with vote table?
  #scope :favorites_of_user, ->(user_id) { joins(:favorites).where(user_id: user_id) }

  def user_image
    self.user.image
  end

end
