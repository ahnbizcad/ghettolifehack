class AddCountersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hacks_count,           :integer, default: 0, null: false
    add_column :users, :comment_threads_count, :integer, default: 0, null: false

    User.reset_column_information
    User.find_each do |u|
      u.update_attribute :hacks_count,           u.hacks.count
      u.update_attribute :comment_threads_count, u.comment_threads.count #comment_threads method necessitated by acts_as_commentable_with_threading gem 
    end
  end

end
