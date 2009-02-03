class AddCounterCacheToCodes < ActiveRecord::Migration
  def self.up
    add_column :codes, :comments_count, :integer, :default => 0
    add_index :codes, :comments_count
    
    Code.reset_column_information
    Code.find(:all, :include => :comments).each do | code | 
      code.update_attribute(:comments_count, code.number_of_comments)
    end
  end

  def self.down
    remove_index :codes, :comments_count
    remove_column :codes, :comments_count
  end
end

