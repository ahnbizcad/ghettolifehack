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

require 'test_helper'

class HackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
