class PartyOpportunity < ActiveRecord::Base
    belongs_to :party
    belongs_to :opportunity
    validates_presence_of :party_id, :opportunity_id  
end
