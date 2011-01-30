module LumberJack
  module Addressable
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def has_many_street_addresses
        has_many :street_addresses, :as => :addressable, :order => "position"
        
        class_eval <<-EOV
          include LumberJack::Addressable::InstanceMethods
        
          def self.find_all_by_street_address(params = {})
            # Searches the street_addresses table for the specified address and returns 
            # an array of addressable objects
            return Array.new if params.nil?
            sa = []
            if params[:postal_code] && params[:street_address]
              StreetAddress.find(:all, :conditions => ["postal_code LIKE ? AND street_address LIKE ?", params[:postal_code] + '%', params[:street_address] + '%']).each do |s|
                sa << s.addressable_type.classify.constantize.find(s.addressable_id)
              end
            end
            sa
          end
        EOV
      end # def
    end # module
    
    module InstanceMethods
      def street_address_for(purpose)
        self.street_addresses.find(
          :first, 
          :conditions => ["purpose LIKE ?", "#{purpose}"], 
          :order => 'position asc')
      end # def
      
      def street_address_best
        self.street_addresses.find(:first, :order => 'position asc')
      end
      
      def method_missing(method_id, *arguments)
        if match = /street_address_for_([_a-zA-Z]\w*)/.match(method_id.to_s)
          self.street_addresses.find(
            :first, 
            :conditions => ["purpose LIKE ?", "%#{$1.to_s.gsub('_', ' ')}%"], 
            :order => 'position asc')
        else
          super
        end
      end # def
    end # module InstanceMethods
  end # module addressable
end # module LumberJack