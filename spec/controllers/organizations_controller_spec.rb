require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe OrganizationsController do
  def get_data_for_sidebar
    @category = Setting.organization_category
  end

  before do
    require_user
    set_current_tab(:organizations)
  end
  # POST /organizations
  # POST /organizations.xml                                                     AJAX
  #----------------------------------------------------------------------------
  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created organization as @organization and render [create] template" do
        @organization = Factory.build(:organization, :name => "Hello world", :user => @current_user)
        Organization.stub!(:new).and_return(@organization)
        @users = [ Factory(:user) ]

        xhr :post, :create, :organization => { :name => "Hello world" }, :users => %w(1 2 3)
        assigns(:party).should == @organization
        assigns(:users).should == @users
        response.should render_template("organizations/create")
      end

      # Note: [Create Organization] is shown only on Organizations index page.
      it "should reload organizations to update pagination" do
        @organization = Factory.build(:organization, :user => @current_user)
        Organization.stub!(:new).and_return(@organization)

        xhr :post, :create, :organization => { :name => "Hello" }, :users => %w(1 2 3)
        assigns[:parties].should == [ @organization ]
      end

      it "should get data to update organization sidebar" do
        @organization = Factory.build(:organization, :name => "Hello", :user => @current_user)
        Campaign.stub!(:new).and_return(@organization)
        @users = [ Factory(:user) ]

        xhr :post, :create, :organization => { :name => "Hello" }, :users => %w(1 2 3)
        assigns[:party_category_total].should be_instance_of(HashWithIndifferentAccess)
      end
    end

    describe "with invalid params" do
      it "should expose a newly created but unsaved organization as @organization and still render [create] template" do
        @organization = Factory.build(:organization, :name => nil, :user => nil)
        Organization.stub!(:new).and_return(@organization)
        @users = [ Factory(:user) ]

        xhr :post, :create, :organization => {}, :users => []
        assigns(:party).should == @organization
        assigns(:users).should == @users
        response.should render_template("organizations/create")
      end
    end

  end
end
