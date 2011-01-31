class CreatePartyOpportunities < ActiveRecord::Migration
  def self.up
    create_table :party_opportunities do |t|
      t.integer  :party_id
      t.integer  :opportunity_id
      t.string   :role, :limit => 32
      t.datetime :deleted_at
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :party_opportunities
  end
end
