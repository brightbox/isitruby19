class AddIndexesToAuthors < ActiveRecord::Migration
  def self.up
    add_index :authorships, [:author_id, :code_id], :name => "authorships_index"
  end

  def self.down
    remove_index :authorships, :name => :authorships_index
  end
end
