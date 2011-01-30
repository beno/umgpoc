# The LumberJack Project is a library of reusable business Models and business logic 
# for use in Rails projects.
module LumberJack
  # The Telephone model is used for Telephone numbers associated with other models. 
  # Telephone is a polymorphic model, so any model in your application can have multiple
  # Telephones. See the Rails documentation for more on Polymorphic Associations.
  #
  # Note that we use attr_accessible to restrict mass assignment to :country_code, 
  # :telephone, :extension, & :purpose
  class Telephone < ActiveRecord::Base
    attr_accessible :country_code, :telephone, :extension, :purpose
    belongs_to :telephonic, :polymorphic => true
    acts_as_list :scope => :telephonic
    validates_presence_of [:country_code, :telephonic_type, :telephonic_id]
    before_validation :normalize_numbers
    validate :valid_telephone?

    # Default country_code is '1'
    # You can change the default country code by placing a file in 
    # 'config/initializers/*.rb with 'Telephone.default_country_code = 'NN' where NN is
    # the country code.
    def self.default_country_code
      @@default_country_code ||= '1'
    end

    # Sets the default_country_code to the value provided.
    def self.default_country_code=(s)
      @@default_country_code = s.to_s
    end

    # Display a formatted string using formatting rules determined by the country code. e.g.
    # 
    #  Organization.telephone_for('Main').try(:display_string) => '(123) 456-7890'
    #
    # I find it more convenient to use this method than to call a view helper for a 
    # formatted string. The display rules here are specific to telephone numbers and not
    # applicable to other parts of the application.
    #
    # If you prefer to use view helpers, then you can simply ignore this method and use
    # the telephone formatting helper methods included in Rails.
    #--
    # TODO: Develop a more modular method to provide a formatted string based on 
    # global format setting. Something like Telephone.display_format = 'FORMAT_DESCRIPTION'
    def display_string
      str = ""
      if country_code == '1' && self.valid?
        str << "+#{country_code} " unless country_code.to_s == Telephone.default_country_code.to_s
        str << telephone.gsub!(/([0-9]{1,3})([0-9]{3})([0-9]{4}$)/,"(\\1) \\2-\\3")
        str << " x #{extension}" unless extension.blank?
      # Add more country specific formats here
      else # Default with minimal format
        str << "+#{country_code} " unless country_code.to_s == Telephone.default_country_code.to_s
        str << "#{telephone}" unless telephone.blank?
        str << " x #{extension}" unless extension.blank?
      end
      str
    end
  
    private
      # remove the junk from country_code, telephone, and extension so we are only dealing
      # with digits.
      def normalize_numbers() #:doc:
        self.country_code = self.country_code.to_s
        self.telephone = self.telephone.to_s
        self.extension = self.extension.to_s
        self.country_code.gsub!(/[^0-9]/, '') unless country_code.blank?
        self.telephone.gsub!(/[^0-9]/, '') unless telephone.blank?
        self.extension.gsub!(/[^0-9]/, '') unless extension.blank?
      end
    
      # validate the telephone based on country-specific validation rules. The validation
      # code looks at the country code for the current instance and validates based on
      # rules for that country
      def valid_telephone?()  #:doc:
        # Validation checks for North American telephones. Keep it simple for now.
        if self.country_code == '1'
          errors.add(:telephone, 'must have 10 digits including area code.') if self.telephone.length != 10
          errors.add(:telephone, 'invalid area code.') if INVALID_AREA_CODES_1.include?(self.telephone[0..2])
          errors.add(:telephone, 'invalid exchange.') if INVALID_EXCHANGES_1.include?(self.telephone[3..5])
          # Add more North American validation checks here
        end
        # Add more Country-specific validation checks here:
      end
  end
  INVALID_AREA_CODES_1 = ['999', '000'] # TODO: Get a full list
  INVALID_EXCHANGES_1 = ['999', '000'] # TODO: Get a full list
end