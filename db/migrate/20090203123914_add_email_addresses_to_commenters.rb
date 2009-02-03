class AddEmailAddressesToCommenters < ActiveRecord::Migration
  def self.up
    add_column :comments, :email, :string, :default => ''
  end

  def self.down
    remove_column :comments, :email
  end
end
