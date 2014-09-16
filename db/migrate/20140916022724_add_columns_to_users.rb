class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image, :string
    add_column :users, :points, :integer, default: 0, null: false
  end
end
