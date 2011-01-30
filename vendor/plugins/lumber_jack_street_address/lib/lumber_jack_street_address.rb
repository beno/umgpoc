# LumberJackStreetAddress
$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'lumber_jack/addressable'
require 'lumber_jack/street_address'
ActiveRecord::Base.send :include, LumberJack::Addressable