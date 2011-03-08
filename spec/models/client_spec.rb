
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Client do

  before { login }

  it "should create a new instance given valid attributes" do
    Client.create!(:name => "Test Client", :user => Factory(:user))
  end

  describe "Attach" do
    before do
      @client = Factory(:client)
    end

    it "should return nil when attaching existing asset" do
      @task = Factory(:task, :asset => @client, :user => @current_user)
      @opportunity = Factory(:opportunity)
      @client.opportunities << @opportunity

      @client.attach!(@task).should == nil
      @client.attach!(@opportunity).should == nil
    end

    it "should return non-empty list of attachments when attaching new asset" do
      @task = Factory(:task, :user => @current_user)
      @opportunity = Factory(:opportunity)

      @client.attach!(@task).should == [ @task ]
      @client.attach!(@opportunity).should == [ @opportunity ]
    end
  end

  describe "Discard" do
    before do
      @client = Factory(:client)
    end

    it "should discard a task" do
      @task = Factory(:task, :asset => @client, :user => @current_user)
      @client.tasks.count.should == 1

      @client.discard!(@task)
      @client.reload.tasks.should == []
      @client.tasks.count.should == 0
    end


    it "should discard an opportunity" do
      @opportunity = Factory(:opportunity)
      @client.opportunities << @opportunity
      @client.opportunities.count.should == 1

      @client.discard!(@opportunity)
      @client.opportunities.should == []
      @client.opportunities.count.should == 0
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

