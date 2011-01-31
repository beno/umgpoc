class AddEmailAddresses < ActiveRecord::Migration
  def self.up
    create_table :email_addresses do |t|
      t.string  :emailable_type
      t.integer :emailable_id
      t.string  :email_address
      t.string  :purpose
      t.string  :verification_code, :limit => 40
      t.date    :verified_on
      t.integer :position
      t.integer :created_by_user_id
      t.integer :modified_by_user_id
      t.integer :lock_version, :default => 0
      t.timestamps
    end
    add_index :email_addresses, :email_address
    add_index :email_addresses, [:emailable_type, :emailable_id]
  end

  def self.down
    drop_table :email_addresses
  end
end
