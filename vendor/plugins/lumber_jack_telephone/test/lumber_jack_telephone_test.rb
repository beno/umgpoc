require File.dirname(__FILE__) + '/test_helper'

class TestOrganization < ActiveRecord::Base
  has_many_telephones
end

class Telephone < LumberJack::Telephone
end

class LumberJackTelephoneTest < Test::Unit::TestCase    
  def setup
    load_schema
    (1..2).each { |i| TestOrganization.create :name => "TestOrganization #{i}"}
    @o1 = TestOrganization.find(1)
    @o1.telephones.build(:country_code => '1', :telephone => '1234567890', :purpose => 'work')
    @o1.telephones.build(:country_code => '1', :telephone => '8005553456', :purpose => 'fax')
    @o1.telephones.build(:country_code => '1', :telephone => '8005551212', :purpose => 'toll free')
    @o1.save
    @o2 = TestOrganization.find(2)
  end
  
  def test_default_country_code
    assert_equal '1', Telephone.default_country_code
    Telephone.default_country_code = '2'
    assert_equal '2', Telephone.default_country_code
    Telephone.default_country_code = '1'
  end
  
  def test_display_string
    assert_equal '(123) 456-7890', Telephone.find(1).display_string
  end
  
  def test_mass_assignment
    params = {:country_code => '1', :telephone => '1234567890', :extension => '2', :purpose => 'Direct', :telephonic_type => 'Hacked', :telephonic_id => 99}
    t = Telephone.new(params)
    assert !t.valid?
    assert "can't be blank", t.errors["telephonic_id"]
    assert "can't be blank", t.errors["telephonic_type"]
    t.telephonic_type = 'Organization'
    t.telephonic_id = 1
    assert t.valid?
    assert 'Organization', t.telephonic_type
    assert 1, t.telephonic_id
    assert '1', t.country_code
    assert '1234567890', t.telephone
    assert '2', t.extension
    assert 'Direct', t.purpose
  end
  
  def test_country_code
    t = Telephone.new(:telephone => '1234567890')
    t.telephonic_type = 'Organization'
    t.telephonic_id = 1
    assert !t.valid?
    t = Telephone.new(:country_code => '2', :telephone => '123456789')
    t.telephonic_type = 'Organization'
    t.telephonic_id = 1
    assert t.valid?
    assert_equal '2', t.country_code
  end
  
  def test_telephone_validations
    t = Telephone.new(:telephone => '1234567890')
    t.telephonic_type = 'Organization'
    t.telephonic_id = 1
    assert !t.valid?
    assert "can't be blank", t.errors["country_code"]
    t = Telephone.new(:country_code => '1', :telephone => '123456789')
    t.telephonic_type = 'Organization'
    t.telephonic_id = 1
    assert !t.valid?
    t = Telephone.new(:country_code => '1', :telephone => '1234567890')
    t.telephonic_type = 'Organization'
    t.telephonic_id = 1
    assert t.valid?
    t = Telephone.new(:country_code => '2', :telephone => '123456789')
    assert_equal '2', t.country_code
    t.telephonic_type = 'Organization'
    t.telephonic_id = 1
    assert t.valid?
    t = Telephone.new(:country_code => '1', :telephone => '9994567890')
    t.telephonic_type = 'Organization'
    t.telephonic_id = 1
    assert !t.valid?
    t = Telephone.new(:country_code => '1', :telephone => '1239997890')
    t.telephonic_type = 'Organization'
    t.telephonic_id = 1
    assert !t.valid?
  end
  
  def test_create_and_count_organizations_and_telephones
    assert_equal 2, TestOrganization.count
    assert_equal 3, @o1.telephones.count
    assert_equal 0, @o2.telephones.count
  end
  
  def test_find_all_by_telephone
    assert_equal 'TestOrganization 1', TestOrganization.find_all_by_telephone(1234567890)[0].name
    assert_equal 0, TestOrganization.find_all_by_telephone('1231231234').size
    assert_equal 0, TestOrganization.find_all_by_telephone(nil).size
  end
  
  def test_telephone_for
    assert_equal '(123) 456-7890', @o1.telephone_for('work').display_string
    assert_equal nil, @o1.telephone_for('main').try(:display_string)
    assert_equal nil, @o2.telephone_for('home').try(:display_string)
    assert_equal nil, @o2.telephone_for(nil).try(:display_string)
  end  
  
  def test_telephone_for_method_missing
    assert_equal '(123) 456-7890', @o1.telephone_for_work.display_string
    assert_equal '(800) 555-1212', @o1.telephone_for_toll_free.display_string
    assert_equal nil, @o1.telephone_for_main.try(:display_string)
    assert_equal nil, @o2.telephone_for_home.try(:display_string)
  end
  
  def test_telephone_best
    assert_equal '(123) 456-7890', @o1.telephone_best.display_string
    @o1.telephone_for('toll free').move_to_top
    assert_equal '(800) 555-1212', @o1.telephone_best.display_string
  end
  
  def test_normalize_numbers
    @o2.telephones.build(:country_code => '+1', :telephone => '(303) 443-2070', :extension => 'x 2', :purpose => 'Test')
    @o2.save!
    assert_equal '3034432070', @o2.telephones[0].telephone
    assert_equal '1', @o2.telephones[0].country_code
    assert_equal '2', @o2.telephones[0].extension
    assert_equal '(303) 443-2070 x 2', @o2.telephone_for('Test').display_string
  end
end
