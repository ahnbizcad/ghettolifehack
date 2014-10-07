class AddFavoritesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favorites_count, :integer, :default => 0, :null => false

    User.reset_column_information
    User.find_each do |u|
      #u.update_attribute :favorites_count, u.favorites.count
      User.reset_counters u.id, :favorites
    end
  end

end
