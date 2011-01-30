ActiveRecord::Schema.define(:version => 1) do
  create_table :test_organizations, :force => true do |t|
    t.string  :name
    t.string  :dba
    t.integer :lock_version, :default => 0
    t.integer :created_by_user_id
    t.integer :modified_by_user_id
    t.integer :position
    t.integer :parent_id
    t.timestamps
  end
  
  create_table :internet_addresses, :force => true do |t|
    t.string   :locatable_type
    t.integer  :locatable_id
    t.string   :protocol
    t.string   :internet_address
    t.string   :purpose
    t.integer  :position
    t.integer  :created_by_user_id
    t.integer  :modified_by_user_id
    t.datetime :deleted_at
    t.integer  :lock_version, :default => 0
    t.timestamps
  end
  add_index :internet_addresses, :internet_address
  add_index :internet_addresses, [:locatable_type, :locatable_id]
end

