class RenameCommentThreadsCountToCommentsCountForUsers < ActiveRecord::Migration
  def change
    rename_column :users, :comment_threads_count, :comments_count
  end
end
