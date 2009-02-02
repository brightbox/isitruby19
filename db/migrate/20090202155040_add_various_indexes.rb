class AddVariousIndexes < ActiveRecord::Migration
  def self.up
    add_index :authors, :name
    add_index :authorships, :code_id
    add_index :authorships, :author_id
    add_index :codes, :name
    add_index :codes, :updated_at
    add_index :comments, :created_at
  end

  def self.down
    remove_index :authors, :name
    remove_index :authorships, :code_id
    remove_index :authorships, :author_id
    remove_index :codes, :name
    remove_index :codes, :updated_at
    remove_index :comments, :created_at
  end
end
