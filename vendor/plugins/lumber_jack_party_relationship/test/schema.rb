ActiveRecord::Schema.define(:version => 1) do
  create_table :parties, :force => true do |t|
    t.string  :type # Single Table Inheritance (STI) type
    t.string  :name # For Organization sub-class
    t.string  :dba # For Organization sub-class
    t.string  :department # For Organization sub-class
    t.string  :salutation # For Person sub-class
    t.string  :first_name # For Person sub-class
    t.string  :middle_name # For Person sub-class
    t.string  :last_name # For Person sub-class
    t.string  :suffix # For Person sub-class
    t.string  :tax_id # Tax ID number
    t.string  :description # background description
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
  
  create_table :relationships, :force => true do |t|
    t.string  :type # Single Table Inheritance (STI) type
    # We are using a "[Party 1] is a [Relationship] of [Party 2]" construct
    # e.g. "[John] is a [Customer] of [Acme]"
    t.integer :is_party_id # Party id for the 'is' part of the relationship
    t.string  :relationship # description of the relationship
    t.integer :of_party_id # Party id for the 'of' part of the relationship
    t.string  :role # Role or Title of the 'of party' (e.g. job title)
    t.date    :started_on # date this relationship started
    t.date    :ended_on # date this relationship ended
    t.integer :created_by_user_id # id for the user who created this
    t.integer :modified_by_user_id # id for the user who modified this
    t.integer :position # position for acts_as_list
    t.integer :lock_version, :default => 0
    t.timestamps
  end
  add_index :relationships, :type
  add_index :relationships, :is_party_id
  add_index :relationships, :relationship
  add_index :relationships, :of_party_id
  add_index :relationships, :created_by_user_id
  add_index :relationships, :modified_by_user_id
end