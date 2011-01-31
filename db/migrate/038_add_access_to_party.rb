class AddAccessToParty < ActiveRecord::Migration
  def self.up
    add_column :parties, :access, :string, :limit => 8,  :default => "Private"
    add_column :parties, :rating, :integer, :default => 0, :null => false
    add_column :parties, :category, :string, :limit => 32
    add_column :parties, :assigned_to, :integer
    add_column :parties, :deleted_at, :datetime
  end

  def self.down
    remove_column :parties, :access
    remove_column :parties, :category
    remove_column :parties, :rating
    remove_column :parties, :assigned_to
    remove_column :parties, :deleted_at
  end
end
