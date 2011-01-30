require File.dirname(__FILE__) + '/test_helper'

class StreetAddress < LumberJack::StreetAddress
end

class TestOrganization < ActiveRecord::Base
  has_many_street_addresses
end

class LumberJackStreetAddressTest < Test::Unit::TestCase  
  def test_truth
    assert true
  end
  
  def setup
    load_schema
    (1..2).each { |i| TestOrganization.create :name => "Organization #{i}"}
    @o1 = TestOrganization.find(1)
    @o1.street_addresses.build(
      :street_address => '3000 Pearl St', :unit_number => '200', :city => 'Boulder', :state => 'CO', 
      :postal_code => '80301', :purpose => 'main')
    @o1.save
  end

  def test_display_string
    assert_equal '3000 Pearl St Unit 200, Boulder, CO 80301', @o1.street_address_for('main').display_string
  end
  
  def test_street_address_for
    a = @o1.street_address_for('main')
    assert_equal '3000 Pearl St', a.street_address
    assert_equal 'Boulder', a.city
    assert_equal 'CO', a.state
    assert_equal '80301', a.postal_code
    assert_equal 'main', a.purpose
    assert_equal '3000 Pearl St Unit 200, Boulder, CO 80301', @o1.street_address_for('main').display_string
    assert_nil @o1.street_address_for('')
    assert_nil @o1.street_address_for(nil)
  end
  
  def test_find_all_by_street_address
    # oa = TestOrganization.find_all_by_street_address('3000 Pearl St, Boulder, CO 80301')
    oa = TestOrganization.find_all_by_street_address(:street_address => '3000 Pearl St', :postal_code => '80301')
    assert_equal 1, oa.size
    assert_equal 1, oa[0].street_addresses.size
    assert_equal '3000 Pearl St', oa[0].street_addresses[0].street_address
    oa = TestOrganization.find_all_by_street_address('')
    assert_equal 0, oa.size
    oa = TestOrganization.find_all_by_street_address(nil)
    assert_equal 0, oa.size
    oa = TestOrganization.find_all_by_street_address(:street_address => '456 Side St', :postal_code => '80301')
    assert_equal 0, oa.size
  end
end
