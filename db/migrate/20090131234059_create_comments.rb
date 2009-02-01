class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :code, :user
      t.text :body
      t.boolean :works_for_me
      t.string :platform
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
