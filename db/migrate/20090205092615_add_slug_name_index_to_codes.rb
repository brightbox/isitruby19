class AddSlugNameIndexToCodes < ActiveRecord::Migration
  def self.up
    add_index :codes, :slug_name
  end

  def self.down
    remove_index :codes, :slug_name
  end
end
