module LumberJack
  module PartyMethods
    module ClassMethods
      def lumber_jack_party
#        attr_accessible :name, :dba, :department, :salutation, :first_name, :middle_name, :last_name, :suffix, :tax_id_number
        acts_as_list
        acts_as_tree
 #       before_save :concatenate_name
        
        class_eval <<-EOV
          include LumberJack::PartyMethods::InstanceMethods
          
          def self.recent(limit = 10)
            self.find(:all, :order => 'updated_at desc', :limit => limit)
          end
        EOV
      end
    end
  
    module InstanceMethods
      def display_name
        unless self.name.blank?
          res = "#{self.name}"
          res << " dba #{self.dba}" unless self.dba.blank?
          res << " #{self.department}" unless self.department.blank?
          res
        else
          res = "#{self.salutation} #{self.first_name} #{self.last_name}"
        end
        res
      end
      
      private
        def concatenate_name
          self.name = "#{self.first_name} #{self.middle_name} #{self.last_name}".gsub('  ', ' ').strip
        end
    end
  
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end
