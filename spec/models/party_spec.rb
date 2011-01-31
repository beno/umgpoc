
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Party do

  before { login }

  it "should create a new instance given valid attributes" do
    Party.create!(:name => "Test Party", :user => Factory(:user))
  end

  describe "Attach" do
    before do
      @party = Factory(:party)
    end

    it "should return nil when attaching existing asset" do
      @task = Factory(:task, :asset => @party, :user => @current_user)
      @opportunity = Factory(:opportunity)
      @party.opportunities << @opportunity

      @party.attach!(@task).should == nil
      @party.attach!(@opportunity).should == nil
    end

    it "should return non-empty list of attachments when attaching new asset" do
      @task = Factory(:task, :user => @current_user)
      @opportunity = Factory(:opportunity)

      @party.attach!(@task).should == [ @task ]
      @party.attach!(@opportunity).should == [ @opportunity ]
    end
  end

  describe "Discard" do
    before do
      @party = Factory(:party)
    end

    it "should discard a task" do
      @task = Factory(:task, :asset => @party, :user => @current_user)
      @party.tasks.count.should == 1

      @party.discard!(@task)
      @party.reload.tasks.should == []
      @party.tasks.count.should == 0
    end


    it "should discard an opportunity" do
      @opportunity = Factory(:opportunity)
      @party.opportunities << @opportunity
      @party.opportunities.count.should == 1

      @party.discard!(@opportunity)
      @party.opportunities.should == []
      @party.opportunities.count.should == 0
    end
  end

#  describe "Exportable" do
#    describe "assigned account" do
#      before do
#        Account.delete_all
#        Factory(:account, :user => Factory(:user), :assignee => Factory(:user))
#        Factory(:account, :user => Factory(:user, :first_name => nil, :last_name => nil), :assignee => Factory(:user, :first_name => nil, :last_name => nil))
#      end
#      it_should_behave_like("exportable") do
#        let(:exported) { Account.all }
#      end
#    end
#
#    describe "unassigned account" do
#      before do
#        Account.delete_all
#        Factory(:account, :user => Factory(:user), :assignee => nil)
#        Factory(:account, :user => Factory(:user, :first_name => nil, :last_name => nil), :assignee => nil)
#      end
#      it_should_behave_like("exportable") do
#        let(:exported) { Account.all }
#      end
#    end
#  end
#
#  describe "Before save" do
#    it "create new: should replace empty category string with nil" do
#      account = Factory.build(:account, :category => '')
#      account.save
#      account.category.should == nil
#    end
#
#    it "update existing: should replace empty category string with nil" do
#      account = Factory(:account, :category => '')
#      account.save
#      account.category.should == nil
#    end
#  end
end

