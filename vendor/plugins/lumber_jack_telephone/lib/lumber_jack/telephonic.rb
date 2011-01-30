# The LumberJack Project is a library of reusable business Models and business logic 
# for use in Rails projects.
module LumberJack
  # The Telephonic module provides ClassMethods and InstanceMethods that are mixed-in
  # to an ActiveRecord model and provide enhanced 'has_many' functionality and Telephone
  # specific methods.
  module Telephonic
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    # These ClassMethods are mixed-in to ActiveRecord and are available to all 
    # ActiveRecord models.
    module ClassMethods
      # By using 'has_many_telephones' in your models, you will receive all of the usual
      # Rails 'has_many' methods plus additional Class and Instance methods as described 
      # herein.
      #
      # The class method 'find_all_by_telephone' will allow you to quickly find 
      # instances of that model with the provided telephone number.  e.g.
      #
      #   class Organization < ActiveRecord::Base
      #     has_many_telephones
      #   end
      #
      #   Organization.find_all_by_telephone('1234567890') => an array of Organizations with the telephone number '1234567890'.
      #
      # Note that this method will retun an empty array if no instances are found.
      def has_many_telephones
        has_many :telephones, :as => :telephonic, :order => "position"
        
        class_eval <<-EOV
          include LumberJack::Telephonic::InstanceMethods
          
          def self.find_all_by_telephone(telephone)
            tn = telephone.to_s.gsub(/[^0-9]/, '')
            ca = []
            Telephone.find(:all, :conditions => ["telephone = ?", tn]).each do |t|
              ca << t.telephonic_type.classify.constantize.find(t.telephonic_id)
            end
            ca
          end
        EOV
      end # def
    end # module
    
    # All instances of the Model (e.g. Organization) will receive these 
    # InstanceMethods:
    module InstanceMethods
      # Organization.telephone_for('Main') => the telephone object with the purpose 'Main'
      # Note that this will return an instance of Telephone (not a String) or nil. 
      def telephone_for(purpose)
        self.telephones.find(
          :first, 
          :conditions => ["purpose LIKE ?", "#{purpose}"], 
          :order => 'position asc')
      end # def
      
      # Organization.telephone_best => the telephone object that has been sorted to the 
      # top of the list (using acts_as_list). Note that this will return an instance of 
      # Telephone (not a String) or nil. 
      def telephone_best
        self.telephones.find(:first, :order => 'position asc')
      end
      
      # This is a method_missing implementation of telephone_for(). Use either one as you 
      # like. (I prefer the regular telephone_for() version).
      #
      # Organization.telephone_for_main => the Telephone object with the purpose 'Main'
      # Note that this will return an instance of Telephone (not a String) or nil.
      def method_missing(method_id, *arguments)
        if match = /telephone_for_([_a-zA-Z]\w*)/.match(method_id.to_s)
          self.telephones.find(
            :first, 
            :conditions => ["purpose LIKE ?", "%#{$1.to_s.gsub('_', ' ')}%"], 
            :order => 'position asc')
        else
          super
        end
      end # def
    end # module InstanceMethods
  end # module Telephonic
end # module LumberJack
