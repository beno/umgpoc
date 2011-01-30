class CreatePartyRelationships < ActiveRecord::Migration
  def self.up
    create_table :party_relationships do |t|
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
    add_index :party_relationships, :type
    add_index :party_relationships, :is_party_id
    add_index :party_relationships, :relationship
    add_index :party_relationships, :of_party_id
    add_index :party_relationships, :created_by_user_id
    add_index :party_relationships, :modified_by_user_id
  end
  
  def self.down
    drop_table :party_relationships
  end
end