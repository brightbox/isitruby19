class AddVersionToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :version, :string
  end

  def self.down
    remove_column :comments, :version
  end
end