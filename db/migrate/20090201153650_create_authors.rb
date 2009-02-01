class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :name
      t.timestamps
    end
    create_table :authorships, :force => true do |t|
      t.references :author, :code
      t.timestamps
    end
  end

  def self.down
    drop_table :authorships
    drop_table :authors
  end
end
