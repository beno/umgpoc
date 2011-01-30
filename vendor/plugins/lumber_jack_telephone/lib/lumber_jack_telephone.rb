$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'lumber_jack/telephonic'
require 'lumber_jack/telephone'
ActiveRecord::Base.send :include, LumberJack::Telephonic