class AddSlugToCodes < ActiveRecord::Migration
  def self.up
    add_column :codes, :slug_name, :string
  end

  def self.down
    remove_column :codes, :slug_name
  end
end
