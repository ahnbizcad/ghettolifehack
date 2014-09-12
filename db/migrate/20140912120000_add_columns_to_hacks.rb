class AddColumnsToHacks < ActiveRecord::Migration
  def change
    add_column     :hacks, :body, :text
    add_reference  :hacks, :user, index: true
  end
end
