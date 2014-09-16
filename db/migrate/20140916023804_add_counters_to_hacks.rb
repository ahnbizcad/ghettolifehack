class AddCountersToHacks < ActiveRecord::Migration
  def change
    add_column :hacks, :comment_threads_count, :integer, default: 0, null: false

    Hack.reset_column_information
    Hack.find_each do |u|
      u.update_attribute :comment_threads_count, u.comment_threads.count #comment_threads method necessitated by acts_as_commentable_with_threading gem 
    end
  end
  
end
