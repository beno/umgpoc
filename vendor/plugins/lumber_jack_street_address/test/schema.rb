ActiveRecord::Schema.define(:version => 1) do
  create_table :test_organizations, :force => true do |t|
    t.string :name
    t.string :dba
    t.integer :lock_version, :default => 0
    t.integer :created_by_user_id
    t.integer :modified_by_user_id
    t.integer :position
    t.integer :parent_id
    t.timestamps
  end

  create_table :street_addresses, :force => true do |t|
    t.string  :addressable_type
    t.integer :addressable_id
    t.string  :purpose
    t.string  :street_address, :limit => 75
    t.string  :street_number, :limit => 10
    t.string  :street_name, :limit => 50
    t.string  :city, :limit => 50
    t.string  :state, :limit => 2 # or province
    t.string  :postal_code, :limit => 10
    t.string  :dpbc, :limit => 2 # for use with custom geocoders
    t.string  :unit_type, :limit => 10 # for use with custom geocoders
    t.string  :unit_number, :limit => 10 # for use with custom geocoders
    t.string  :search_key, :limit => 25 # for use with custom geocoders
    t.string  :address_type, :limit => 1 # for use with custom geocoders
    t.string  :fips, :limit => 5 # for use with custom geocoders
    t.string  :msa, :limit => 4 # for use with custom geocoders
    t.string  :csa, :limit => 4 # for use with custom geocoders
    t.string  :cbsa, :limit => 5 # for use with custom geocoders
    t.decimal :latitude, :precision => 9, :scale => 6
    t.decimal :longitude, :precision => 9, :scale => 6
    t.string  :census_tract_number, :limit => 10 # for use with custom geocoders
    t.string  :census_block_number, :limit => 10 # for use with custom geocoders
    t.string  :country_code, :limit => 2
    t.boolean :geocode_attempted, :default => false
    t.string  :geokit_provider, :limit => 25
    t.string  :geokit_precision, :limit => 25
    t.integer :geokit_accuracy
    t.string  :return_code, :limit => 5 # for use with custom geocoders
    t.integer :position
    t.integer :created_by_user_id
    t.integer :modified_by_user_id
    t.integer :lock_version, :default => 0
    t.timestamps
  end
  add_index :street_addresses, [:addressable_type, :addressable_id]
  add_index :street_addresses, :search_key
  add_index :street_addresses, [:postal_code, :state, :city, :street_address]
end