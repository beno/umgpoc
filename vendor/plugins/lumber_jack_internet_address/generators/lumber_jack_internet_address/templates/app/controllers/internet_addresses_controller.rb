# Assumes that InternetAddresss will always be accessed from a parent controller.
# In views, use polymorphic path helpers:
# polymorphic_url([@locatable, internet_address])
class InternetAddressesController < ApplicationController
  before_filter :find_locatable
  # GET /internet_addresses
  # GET /internet_addresses.xml
  def index
    @internet_addresses = @locatable.internet_addresses
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @internet_addresses }
    end
  end

  # GET /internet_addresses/1
  # GET /internet_addresses/1.xml
  def show
    @internet_address = @locatable.internet_addresses.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @internet_address }
    end
  end

  # GET /internet_addresses/new
  # GET /internet_addresses/new.xml
  def new
    @internet_address = @locatable.internet_addresses.new
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @internet_address }
    end
  end

  # GET /internet_addresses/1/edit
  def edit
    @internet_address = @locatable.internet_addresses.find(params[:id])
  end

  # POST /internet_addresses
  # POST /internet_addresses.xml
  def create
    @internet_address = @locatable.internet_addresses.new(params[:internet_address])
    assign_user_id_on_create
    respond_to do |format|
      if @internet_address.save
        flash[:notice] = 'InternetAddress was successfully created.'
        format.html { redirect_to(@internet_address.locatable) }
        format.xml  { render :xml => @internet_address, :status => :created, :location => @internet_address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @internet_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /internet_addresses/1
  # PUT /internet_addresses/1.xml
  def update
    @internet_address = @locatable.internet_addresses.find(params[:id])
    assign_user_id_on_update
    respond_to do |format|
      if @internet_address.update_attributes(params[:internet_address])
        flash[:notice] = 'InternetAddress was successfully updated.'
        format.html { redirect_to(@internet_address.locatable) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @internet_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /internet_addresses/1
  # DELETE /internet_addresses/1.xml
  def destroy
    @internet_address = @locatable.internet_addresses.find(params[:id])
    @internet_address.destroy
    
    respond_to do |format|
      format.html { redirect_to(@locatable) }
      format.xml  { head :ok }
    end
  end

  def sort
    params[:internet_addresses].each_with_index do |id, index|
      InternetAddress.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

  private
    def find_locatable
      @locatable = nil
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @locatable = $1.classify.constantize.find(value)
        end
      end
      @locatable
    end
    
    def assign_user_id_on_create
      if defined?(current_user)
        @internet_address.created_by_user_id = current_user.id
        @internet_address.modified_by_user_id = current_user.id
      end
    end

    def assign_user_id_on_update
      @internet_address.modified_by_user_id = current_user.id if defined?(current_user)
    end
end