$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'lumber_jack/locatable'
require 'lumber_jack/internet_address'
ActiveRecord::Base.class_eval { include LumberJack::Locatable }