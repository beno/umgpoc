module PartyModel
  class Party < ActiveRecord::Base
    lumber_jack_party
    belongs_to  :user
    belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
    has_many :party_opportunities, :dependent => :destroy
    has_many :opportunities, :through => :party_opportunities, :uniq => true, :order => "opportunities.id DESC"
    has_many :emails, :as => :mediator
    has_many :tasks, :as => :asset, :dependent => :destroy, :order => 'created_at DESC'
    
    has_many :is_party_relationships, :class_name => 'PartyRelationship', :foreign_key => :is_party_id
    has_many :of_party_relationships, :class_name => 'PartyRelationship', :foreign_key => :of_party_id
    
    
    #exportable
    sortable :by => [ "name ASC", "created_at DESC", "updated_at DESC" ], :default => "created_at DESC"
    uses_user_permissions
    acts_as_commentable
    
    
    
    def self.per_page ; 20     ; end
    def self.outline  ; "long" ; end
      
    has_many_street_addresses
    accepts_nested_attributes_for :street_addresses, :reject_if => lambda {|a| a[:street_address].blank?}, :allow_destroy => true
    has_many_telephones
    accepts_nested_attributes_for :telephones, :reject_if => lambda {|t| t[:telephone].blank?}, :allow_destroy => true
    has_many_email_addresses
    accepts_nested_attributes_for :email_addresses, :reject_if => lambda {|e| e[:email_address].blank?}, :allow_destroy => true
    
  
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
