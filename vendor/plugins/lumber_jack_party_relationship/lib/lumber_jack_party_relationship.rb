# LumberJackPartyRelationship
$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'lumber_jack/party_relationship_methods'
ActiveRecord::Base.class_eval { include LumberJack::PartyRelationshipMethods }
# ActiveRecord::Base.send :include, LumberJack::Telephonic