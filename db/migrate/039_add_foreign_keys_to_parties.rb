class AddForeignKeysToParties < ActiveRecord::Migration
  def self.up
    add_column :parties, :legacy_id, :integer, :unique => true
    add_column :parties, :intrasurance_id, :integer, :unique => true
    add_column :parties, :user_id, :integer
  end

  def self.down
    remove_column :parties, :legacy_id
    remove_column :parties, :intrasurance_id
    remove_column :parties, :user_id
  end
end
