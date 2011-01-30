$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'lumber_jack/emailable'
require 'lumber_jack/email_address'
# require 'lumber_jack/email_addresses_controller'
ActiveRecord::Base.class_eval { include LumberJack::Emailable }

