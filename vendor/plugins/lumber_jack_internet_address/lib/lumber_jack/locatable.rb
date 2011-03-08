module LumberJack
  module Locatable
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def has_many_internet_addresses(class_name = nil)
        has_many :internet_addresses, :as => :locatable, :order => "position", :class_name => class_name
        
        class_eval <<-EOV
          include LumberJack::Locatable::InstanceMethods
          
          def self.find_all_by_internet_address(internet_address)
            # Searches the internet_addresses table for the specified address and returns 
            # an array of Locatable objects
            ea = []
            return ea if internet_address.blank?
            InternetAddress.find(:all, :conditions => ["internet_address LIKE ?", '%' + internet_address.to_s + '%']).each do |t|
              ea << t.locatable_type.classify.constantize.find(t.locatable_id)
            end
            ea
          end
        EOV
      end # def
    end # module
    
    module InstanceMethods
      def internet_address_for(purpose)
        self.internet_addresses.find(
          :first, 
          :conditions => ["purpose LIKE ?", "%#{purpose}%"], 
          :order => 'position asc')
      end # def
      
      def internet_address_best
        self.internet_addresses.find(:first, :order => 'position asc')
      end
      
      def method_missing(method_id, *arguments)
        if match = /internet_address_for_([_a-zA-Z]\w*)/.match(method_id.to_s)
          self.internet_addresses.find(
            :first, 
            :conditions => ["purpose LIKE ?", "%#{$1.to_s.gsub('_', ' ')}%"], 
            :order => 'position asc')
        else
          super
        end
      end # def
    end # module InstanceMethods
  end # module Locatable
end # module LumberJack
