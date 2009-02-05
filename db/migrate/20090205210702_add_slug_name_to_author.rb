class AddSlugNameToAuthor < ActiveRecord::Migration
  def self.up
    add_column :authors, :slug_name, :string
    Author.update_all_slug_names
  end

  def self.down
    remove_column :authors, :slug_name
  end
end
