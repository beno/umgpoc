class Contact < PartyRelationship
  belongs_to :person, :class_name => 'Person', :foreign_key => :is_party_id
  belongs_to :organization, :class_name => 'Organization', :foreign_key => :of_party_id
end