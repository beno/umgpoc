require File.dirname(__FILE__) + '/test_helper'

class ApplicationController < ActionController::Base
end

class TestOrganization < ActiveRecord::Base
  has_many_internet_addresses
end

class InternetAddress < LumberJack::InternetAddress
end

class LumberJackInternetAddressTest < Test::Unit::TestCase 
  def setup
    load_schema
    (1..2).each { |i| TestOrganization.create :name => "TestOrganization #{i}"}
    @o1 = TestOrganization.find(1)
    @o1.internet_addresses.build(:protocol => 'http://', :internet_address => 'www.organization.com', :purpose => 'main')
    @o1.internet_addresses.build(:protocol => 'http://', :internet_address => 'intranet.organization.com', :purpose => 'intranet')
    @o1.save
    @o2 = TestOrganization.find(2)
  end
  
  def test_truth
    assert true
  end
  
  def test_internet_address_validations
    e = InternetAddress.new(:protocol => 'http://', :internet_address => 'www.organization.com')
    assert e.valid?
    e = InternetAddress.new()
    assert !e.valid?
    assert_equal 'Cannot Be Blank', e.errors.on(:protocol)
    assert_equal 'Cannot Be Blank', e.errors.on(:internet_address)
    e = InternetAddress.new(:internet_address => '')
    assert !e.valid?
    assert_equal 'Cannot Be Blank', e.errors.on(:internet_address)
  end
  
  def test_create_and_count_organizations_and_internet_addresses
    assert_equal 2, TestOrganization.count
    assert_equal 2, @o1.internet_addresses.count
    assert_equal 0, @o2.internet_addresses.count
  end
  
  def test_display_string
    assert_equal 'www.organization.com', InternetAddress.find(1).display_string
    assert_equal 'intranet.organization.com', InternetAddress.find(2).display_string
  end
  
  def test_to_s
    assert_equal 'http://www.organization.com', InternetAddress.find(1).to_s
    assert_equal 'http://intranet.organization.com', InternetAddress.find(2).to_s
  end
  
  def test_internet_address_for
    assert_equal 'www.organization.com', @o1.internet_address_for_main.try(:display_string)
    assert_nil @o1.internet_address_for('school')
  end
  
  def test_find_all_by_internet_address
    assert_equal 'TestOrganization 1', TestOrganization.find_all_by_internet_address('www.organization.com')[0].name
    assert_equal 0, TestOrganization.find_all_by_internet_address(nil).size
  end
  
  def test_internet_address_for_method_missing
    assert_equal 'www.organization.com', @o1.internet_address_for_main.try(:display_string)
    assert_equal 'intranet.organization.com', @o1.internet_address_for_intranet.try(:display_string)
    assert_nil @o1.internet_address_for('school')
  end
  
  def test_internet_address_best
    assert_equal 'www.organization.com', @o1.internet_address_best.try(:display_string)
  end
end
