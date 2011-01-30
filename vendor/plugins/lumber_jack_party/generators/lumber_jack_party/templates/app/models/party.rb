class Party < ActiveRecord::Base
  lumber_jack_party
  # has_many_notes # Use this if you have installed LumberJack::Note
  # has_many_telephones # Use this if you have installed LumberJack::Telephone
  # is_contactable # Use this if you have installed LumberJack::Contact
  # has_many :is_party_relationships, :class_name => 'PartyRelationship', :foreign_key => :is_party_id
  # has_many :of_party_relationships, :class_name => 'PartyRelationship', :foreign_key => :of_party_id
end
