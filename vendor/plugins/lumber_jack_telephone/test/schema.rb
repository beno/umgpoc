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

  create_table :telephones, :force => true do |t|
    t.string  :telephonic_type
    t.integer :telephonic_id
    t.string  :country_code
    t.string  :telephone
    t.string  :extension
    t.string  :purpose
    t.integer :position
    t.integer :created_by_user_id
    t.integer :modified_by_user_id
    t.integer :lock_version, :default => 0
    t.timestamps
  end
end

