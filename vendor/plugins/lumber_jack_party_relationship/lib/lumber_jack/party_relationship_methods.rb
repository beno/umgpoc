module LumberJack
  module PartyRelationshipMethods
    module ClassMethods
      def lumber_jack_party_relationship
        acts_as_list

        class_eval <<-EOV
          include LumberJack::PartyRelationshipMethods::InstanceMethods

          belongs_to :is_party, :class_name => 'Party', :foreign_key => :is_party_id
          belongs_to :of_party, :class_name => 'Party', :foreign_key => :of_party_id
          before_create :set_start_date
          validates_presence_of [:is_party_id, :of_party_id]
          
          def self.recent(p = {})
            limit = p[:limit] || 10
            self.find(:all, :order => 'updated_at desc', :limit => limit)
          end
        EOV
      end
    end
  
    module InstanceMethods
      def active?
        ended_on.nil?
      end
      
      def deactivate
        update_attribute(:ended_on, Date.today)
      end
      
      def reactivate
        update_attribute(:ended_on, nil)
      end
      
      def describe
        s = "#{is_party.display_name} is a #{relationship} of #{of_party.display_name} (Started on #{started_on})"
        s << " (Inactive)" unless self.active?
        s
      end

      def display_string
        "#{is_party.display_name} is #{relationship} of #{of_party.display_name}"
      end

      private
        def set_start_date
          self.started_on = Date.today
        end
    end
  
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end