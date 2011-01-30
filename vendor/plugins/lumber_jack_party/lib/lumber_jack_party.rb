# LumberJackParty
$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'lumber_jack/party_methods'
ActiveRecord::Base.send :include, LumberJack::PartyMethods