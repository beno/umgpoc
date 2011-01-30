ActiveRecord::Schema.define(:version => 1) do
  create_table :parties, :force => true do |t|
    t.string  :type # For STI
    t.string  :name # For Organizations
    t.string  :dba # For Organizations
    t.string  :department # For Organizations
    t.string  :salutation # For People
    t.string  :first_name # For People
    t.string  :middle_name # For People
    t.string  :last_name # For People
    t.string  :suffix # For People
    t.string  :tax_id_number
    t.integer :created_by_user_id # id for the user who created this
    t.integer :modified_by_user_id # id for the user who modified this
    t.integer :position # position for acts_as_list
    t.integer :parent_id # parent id for acts_as_tree
    t.integer :lock_version, :default => 0
    t.timestamps
  end
  add_index :parties, :type
  add_index :parties, :name
  add_index :parties, [:last_name, :first_name]
  add_index :parties, :parent_id
  add_index :parties, :created_by_user_id
  add_index :parties, :modified_by_user_id
end