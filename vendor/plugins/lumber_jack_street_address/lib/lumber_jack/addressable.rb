module LumberJack
  module Addressable
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def has_many_street_addresses(klass_name = nil)
        has_many :street_addresses, :as => :addressable, :order => "position", :class_name => klass_name
        
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

      def street_addresses_for(purpose)
        self.street_addresses.find(
          :all, 
          :conditions => ["purpose LIKE ?", "#{purpose}"], 
          :order => 'position asc')
      end # def
      
      def assign_street_address_for!(purpose, address)
        address.purpose = purpose
        address.addressable = self
        address.insert_at(1)
        save
      end

      def street_address_best
        self.street_addresses.find(:first, :order => 'position asc')
      end
      
      def method_missing(method_name, *arguments)
        case method_name
        when /street_address_for_([_a-zA-Z]\w*)=/
          purpose = $1.to_s.gsub('_', ' ')
          address = arguments[0]
          assign_street_address_for! purpose, address
        when /street_address_for_([_a-zA-Z]\w*)/
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
