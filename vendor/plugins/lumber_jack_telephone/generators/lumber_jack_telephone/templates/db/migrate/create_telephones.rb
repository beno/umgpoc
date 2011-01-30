class CreateTelephones < ActiveRecord::Migration
  def self.up
    create_table :telephones do |t|
      t.string   :telephonic_type # polymorphic type
      t.integer  :telephonic_id # polymorphic id
      t.string   :country_code # a number that we process like a string
      t.string   :telephone # a number that we process like a string
      t.string   :extension # a number that we process like a string
      t.string   :purpose # the telephone's purpose ('work', 'home', etc.)
      t.integer  :position # acts_as_list
      t.integer  :created_by_user_id
      t.integer  :modified_by_user_id
      t.datetime :deleted_at # paranoid
      t.integer  :lock_version, :default => 0
      t.timestamps
    end
    add_index :telephones, :telephone
    add_index :telephones, [:telephonic_type, :telephonic_id]
  end

  def self.down
    drop_table :telephones
  end
end
