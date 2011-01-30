require File.dirname(__FILE__) + '/test_helper'

class ApplicationController < ActionController::Base
end

class Organization < ActiveRecord::Base
  has_many_email_addresses
end

class EmailAddress < LumberJack::EmailAddress
end


class LumberJackEmailAddressTest < Test::Unit::TestCase 
  def setup
    load_schema
    (1..2).each { |i| Organization.create :name => "Organization #{i}"}
    @o1 = Organization.find(1)
    @o1.email_addresses.build(:email_address => 'john.doe@organization.com', :purpose => 'work')
    @o1.email_addresses.build(:email_address => 'john.doe@gmail.com', :purpose => 'home')
    @o1.save
    @o2 = Organization.find(2)
  end
  
  
  def test_email_address_validations
   e = EmailAddress.new(:email_address => 'john.doe@organization.com')
      assert e.valid?
      e = EmailAddress.new(:email_address => 'john.doe')
      assert !e.valid?
      e = EmailAddress.new(:email_address => 'john.doe@organization')
      assert !e.valid?
  end
  
  def test_create_and_count_organizations_and_email_addresses
      assert_equal 2, Organization.count
      assert_equal 2, @o1.email_addresses.count
      assert_equal 0, @o2.email_addresses.count
  end
  
  def test_email_address_for
    assert_equal 'john.doe@organization.com', @o1.email_address_for_work.format
    assert_nil @o1.email_address_for('school')
  end


  def test_find_all_by_email_address
    assert_equal 'Organization 1', Organization.find_all_by_email_address('john.doe@organization.com')[0].name
    assert_equal 0, Organization.find_all_by_email_address(nil).size
  end

  def test_email_address_for_method_missing
    assert_equal 'john.doe@organization.com', @o1.email_address_for_work.format
    assert_equal 'john.doe@gmail.com', @o1.email_address_for_home.format
    assert_nil @o1.email_address_for('school')
  end

  def test_email_address_best
    assert_equal 'john.doe@organization.com', @o1.email_address_best.format
  end
  
end
