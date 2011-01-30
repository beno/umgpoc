module  LumberJack
  class EmailAddress < ActiveRecord::Base
    belongs_to :emailable, :polymorphic => true
    acts_as_list :scope => :emailable
    validate :valid_email_address?
    
    
    
    def format
      email_address.downcase
    end
    
    private
      # Basic validation for formatting using English characters
      def valid_email_address?
        unless email_address.blank?
          valid = '[A-Za-z\d.+-]+'
          unless email_address =~ /#{valid}@#{valid}\.#{valid}/
            errors.add(:email_address, "Your email address does not appear to be valid")
          end
        end
      end
      
             
  end
end


