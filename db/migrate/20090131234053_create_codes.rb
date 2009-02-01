class CreateCodes < ActiveRecord::Migration
  def self.up
    create_table :codes do |t|
      t.string :name, :description, :homepage, :rubyforge, :github, :type
      t.decimal :latest_version
      t.timestamps
    end
  end

  def self.down
    drop_table :codes
  end
end
