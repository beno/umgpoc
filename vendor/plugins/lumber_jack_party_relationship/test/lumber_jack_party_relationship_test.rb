require File.dirname(__FILE__) + '/test_helper'

class Party < LumberJack::Party
end

class Relationship < LumberJack::Relationship
end

class Person < Party
  has_many :employers, :class_name => 'Job', :foreign_key => :is_party_id,
    :conditions => "relationship LIKE 'Employee'" do
      def create_new_employer(organization)
        create(:of_party_id => organization.id)
      end
  end
end

class Organization < Party
  has_many :employees, :class_name => 'Job', :foreign_key => :of_party_id,
    :conditions => "relationship LIKE 'Employee'" do 
      def create_new_employee(person)
        create(:is_party_id => person.id)
      end
  end
end

class Job < Relationship
  belongs_to :employee, :class_name => 'Person', :foreign_key => :is_party_id
  belongs_to :employer, :class_name => 'Organization', 
    :foreign_key => :of_party_id
  before_create :set_relationship
  
  private
    def set_relationship
      self.relationship = 'Employee'
    end
end

class LumberJackPartyRelationshipTest < Test::Unit::TestCase
  def setup
    load_schema
  end
  
  def create_party_fixtures
    @p1 = Party.create(:name => 'Party 1')
    @p2 = Party.create(:name => 'Party 2')
  end
  
  def test_party_relationships
    create_party_fixtures
    assert_equal 'Party 1', @p1.display_name
    assert_equal 'Party 2', @p2.display_name
    # Create an ad-hoc relationship:
    r = Relationship.create(
      :is_party_id => @p1.id, 
      :relationship => 'Customer', 
      :of_party_id => @p2.id)
    assert_equal 'Party 1 is a Customer of Party 2', r.describe
    assert_equal Date.today, r.started_on
    assert_equal 'Customer', @p1.is_relationships[0].relationship
    assert_equal 'Party 2',
      @p1.is_relationships[0].of_party.display_name
    assert_equal 'Customer', @p2.of_relationships[0].relationship
    assert_equal 'Party 1',
      @p2.of_relationships[0].is_party.display_name
  end
  
  def test_party_organization_person
    @o = Organization.create(:name => 'Organization 1')
    @p = Person.create(:last_name => 'Doe', :first_name => 'John')
    # Create a job relationship:
    @job = @o.employees.create_new_employee(@p)
    # OR:
    #@job = @o.employees.create(:is_party_id => @p.id)
    # OR:
    # @job = @p.employers.create_new_employer(@o)
    # OR:
    # @job = @p.employers.create(:of_party_id => @o.id)
    # OR:
    # @job = Job.create(:is_party_id => @p.id, :of_party_id => @o.id)
    assert_equal 'John Doe is a Employee of Organization 1', @job.describe
    assert_equal 1, @o.employees.size
    assert_equal 'John Doe', @o.employees[0].employee.try(:display_name)
    assert_equal 'Organization 1',
      @p.employers[0].employer.try(:display_name)
    # Create an ad-hoc relationship:
    @c = Relationship.create(
      :is_party_id => @p.id,
      :relationship => 'Customer',
      :of_party_id => @o.id)
    assert_equal 'John Doe is a Customer of Organization 1', 
      @c.describe
    assert_equal Date.today, @c.started_on
    assert_equal 2, @o.of_relationships.size
    assert_equal 1, @o.employees.size
  end
end