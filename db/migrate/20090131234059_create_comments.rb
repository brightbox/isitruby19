class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :code, :platform
      t.text :body
      t.boolean :works_for_me
      t.string :name, :url
      t.timestamps
    end
    
    add_index :comments, :code_id
  end

  def self.down
    drop_table :comments
  end
end
