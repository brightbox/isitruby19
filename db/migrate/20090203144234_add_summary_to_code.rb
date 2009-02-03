class AddSummaryToCode < ActiveRecord::Migration
  def self.up
    add_column :codes, :summary, :text
  end

  def self.down
    remove_column :codes, :summary
  end
end
