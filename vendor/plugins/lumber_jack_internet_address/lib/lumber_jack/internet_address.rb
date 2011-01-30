module  LumberJack
  class InternetAddress < ActiveRecord::Base
    belongs_to :locatable, :polymorphic => true
    acts_as_list :scope => :locatable
    validate :valid_internet_address?
    attr_accessible :protocol, :internet_address, :purpose
    
    def display_string
      return internet_address.downcase if uri.class == URI::Generic
      return uri.to.downcase if uri.class == URI::MailTo
      return uri.host.downcase
    end
    
    # def to_s
    #   return uri.to_s.downcase
    # end
    
    private
      def uri
        URI.parse("#{protocol}#{internet_address}")
      end
    
      def valid_internet_address?
        begin
          errors.add(:protocol, "Cannot Be Blank") if protocol.blank?
          errors.add(:internet_address, "Cannot Be Blank") if internet_address.blank?
          uri = URI.parse("#{protocol}#{internet_address}")
          # More validations on uri go here
        rescue URI::InvalidURIError
          errors.add_to_base "Invalid Internet Address or Protocol"
        end
        true
      end
  end
end