class AddCachedTagListToHacks < ActiveRecord::Migration
  def change
    add_column :hacks, :cached_tag_list, :string
    Hack.reset_column_information
    ActsAsTaggableOn::Taggable::Cache.included(Hack)
    Hack.find_each(batch_size: 1000) do |h|
      h.tag_list
      h.save!
    end
  end
end
