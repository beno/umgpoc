module PartyModel  
  module Partyable
    def self.included(base)
      base.instance_eval do
        lumber_jack_party
        
        has_many :is_party_relationships, :class_name => 'PartyModel::PartyRelationship', :foreign_key => :is_party_id
        accepts_nested_attributes_for :is_party_relationships, :reject_if => lambda {|r| r[:of_party_id].blank?}, :allow_destroy => true
        has_many :of_party_relationships, :class_name => 'PartyModel::PartyRelationship', :foreign_key => :of_party_id
        accepts_nested_attributes_for :of_party_relationships, :reject_if => lambda {|r| r[:of_party_id].blank?}, :allow_destroy => true
        
        has_many_street_addresses "PartyModel::StreetAddress"
        accepts_nested_attributes_for :street_addresses, :reject_if => lambda {|a| a[:postal_code].blank?}, :allow_destroy => true
        has_many_telephones "PartyModel::Telephone"
        accepts_nested_attributes_for :telephones, :reject_if => lambda {|t| t[:telephone].blank?}, :allow_destroy => true
        has_many_email_addresses "PartyModel::EmailAddress"
        accepts_nested_attributes_for :email_addresses, :reject_if => lambda {|e| e[:email_address].blank?}, :allow_destroy => true
        has_many_internet_addresses "PartyModel::InternetAddress"
        accepts_nested_attributes_for :internet_addresses, :reject_if => lambda {|e| e[:internet_address].blank?}, :allow_destroy => true
      end
    end
  
    # has_many_notes # Use this if you have installed LumberJack::Note
    # has_many_telephones # Use this if you have installed LumberJack::Telephone
    # is_contactable # Use this if you have installed LumberJack::Contact
    # has_many :is_party_relationships, :class_name => 'PartyRelationship', :foreign_key => :is_party_id
    # has_many :of_party_relationships, :class_name => 'PartyRelationship', :foreign_key => :of_party_id
    
    def contacts
      is_party_relationships.select do |relationship|
        relationship.class.name.demodulize == "Contact"
      end
    end

  end
end
