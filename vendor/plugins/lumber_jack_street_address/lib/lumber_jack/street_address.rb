# LumberJack::StreetAddress
require 'geokit'
module LumberJack
  class StreetAddress < ActiveRecord::Base
    belongs_to :addressable, :polymorphic => true
    acts_as_list :scope => :addressable
    before_validation :geocode
        
    def display_string
      s = ""
      s << "#{street_address}" unless street_address.blank?
      s << " Unit #{unit_number}" unless unit_number.blank?
      s << ", #{city}" unless city.blank?
      s << ", #{state}" unless state.blank?
      s << " #{postal_code}" unless postal_code.blank?
      s.strip
    end
    
    def zip_5
      postal_code[0..4]
    end
    
    # Where we are going with this:
    def directions_from(address)
    end
    
    def directions_to(address)
    end
    
    def distance_from(address)
    end
      
    def distance_to(address)
    end

    private
      def geocode
        unless geocode_attempted
          g = Geokit::Geocoders::MultiGeocoder.geocode("#{street_address}, #{city}, #{state}, #{postal_code}")
          if g.success
            self.street_address = g.street_address
            self.city = g.city
            self.state = g.state
            self.postal_code = g.zip
            self.latitude = g.lat
            self.longitude = g.lng
            self.country_code = g.country_code
            self.geokit_provider = g.provider
            self.geokit_precision = g.precision
            self.geokit_accuracy = g.accuracy
          end
          self.geocode_attempted = true
        end
      end
  end
end
