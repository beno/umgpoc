class CreateInternetAddresses < ActiveRecord::Migration
  def self.up
    create_table :internet_addresses do |t|
      t.string   :locatable_type
      t.integer  :locatable_id
      t.string   :protocol
      t.string   :internet_address
      t.string   :purpose
      t.integer  :position # For acts_as_list
      t.integer  :created_by_user_id
      t.integer  :modified_by_user_id
      t.datetime :deleted_at # For acts_as_paranoid
      t.integer  :lock_version, :default => 0
      t.timestamps
    end
    add_index :internet_addresses, :internet_address
    add_index :internet_addresses, [:locatable_type, :locatable_id]
    add_index :internet_addresses, :deleted_at
  end

  def self.down
    drop_table :internet_addresses
  end
end
