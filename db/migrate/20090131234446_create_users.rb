class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :name
      t.string    :email
      t.string    :homepage
      t.string    :login,                 :null => false
      t.string    :crypted_password,      :null => false
      t.string    :password_salt,         :null => false
      t.string    :persistence_token,     :null => false
      t.string    :single_access_token,   :null => false # optional, see the tokens section below.
      t.string    :perishable_token,      :null => false # optional, see the tokens section below.
      t.integer   :login_count,           :null => false, :default => 0 # optional, this is a "magic" column, see the magic columns section below
      t.timestamps
      t.boolean :is_admin
    end
  end

  def self.down
    drop_table :users
  end
end
