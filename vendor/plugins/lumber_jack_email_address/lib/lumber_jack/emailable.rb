module LumberJack
  module Emailable
    def self.included(base)
      base.extend(ClassMethods)
    end
    
  module ClassMethods
      def has_many_email_addresses(class_name = nil)
        has_many :email_addresses, :as => :emailable, :order => "position", :class_name => class_name
        
        class_eval <<-EOV
          include LumberJack::Emailable::InstanceMethods
          
          def self.find_all_by_email_address(email_address)
            # Searches the email_addresses table for the specified address and returns 
            # an array of Emailable objects
            ea = []
            EmailAddress.find(:all, :conditions => ["email_address LIKE ?", email_address.to_s]).each do |t|
              ea << t.emailable_type.classify.constantize.find(t.emailable_id)
            end
            ea
          end
        EOV
      end # def
    end # module
    
    module InstanceMethods
      def email_address_for(purpose)
        self.email_addresses.find(
          :first, 
          :conditions => ["purpose LIKE ?", "%#{purpose}%"], 
          :order => 'position asc')
      end # def
      
      def email_address_best
        self.email_addresses.find(:first, :order => 'position asc')
      end
      
      def method_missing(method_id, *arguments)
        if match = /email_address_for_([_a-zA-Z]\w*)/.match(method_id.to_s)
          self.email_addresses.find(
            :first, 
            :conditions => ["purpose LIKE ?", "%#{$1.to_s.gsub('_', ' ')}%"], 
            :order => 'position asc')
        else
          super
        end
      end # def
    end # module InstanceMethods
  end # module Emailable
end # module LumberJack
