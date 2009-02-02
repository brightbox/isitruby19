class RenameTypeFieldInCodes < ActiveRecord::Migration
  def self.up
    rename_column :codes, :type, :code_type
  end

  def self.down
    rename_column :codes, :code_type, :type
  end
end