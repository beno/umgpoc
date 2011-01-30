# Assumes that street_addresses will always be accessed from a parent controller.
# In views, use polymorphic path helpers:
# polymorphic_url([@addressable, street_address])
class StreetAddressesController < ApplicationController
  before_filter :find_addressable
  # GET /street_addresses
  # GET /street_addresses.xml
  def index
    @street_addresses = @addressable.street_addresses
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @street_addresses }
    end
  end

  # GET /street_addresses/1
  # GET /street_addresses/1.xml
  def show
    @street_address = @addressable.street_addresses.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @street_address }
    end
  end

  # GET /street_addresses/new
  # GET /street_addresses/new.xml
  def new
    @street_address = @addressable.street_addresses.new
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @street_address }
    end
  end

  # GET /street_addresses/1/edit
  def edit
    @street_address = @addressable.street_addresses.find(params[:id])
  end

  # POST /street_addresses
  # POST /street_addresses.xml
  def create
    @street_address = @addressable.street_addresses.new(params[:street_address])
    assign_user_id_on_create
    respond_to do |format|
      if @street_address.save
        flash[:notice] = 'street_address was successfully created.'
        format.html { redirect_to(@street_address.addressable) }
        format.xml  { render :xml => @street_address, :status => :created, :location => @street_address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @street_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /street_addresses/1
  # PUT /street_addresses/1.xml
  def update
    @street_address = @addressable.street_addresses.find(params[:id])
    assign_user_id_on_update
    respond_to do |format|
      if @street_address.update_attributes(params[:street_address])
        flash[:notice] = 'street_address was successfully updated.'
        format.html { redirect_to(@street_address.addressable) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @street_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /street_addresses/1
  # DELETE /street_addresses/1.xml
  def destroy
    @street_address = @addressable.street_addresses.find(params[:id])
    @street_address.destroy
    
    respond_to do |format|
      format.html { redirect_to(@addressable) }
      format.xml  { head :ok }
    end
  end

  def sort
    params[:street_addresses].each_with_index do |id, index|
      StreetAddress.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

  private
    def find_addressable
      @addressable = nil
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @addressable = $1.classify.constantize.find(value)
        end
      end
      @addressable
    end
    
    def assign_user_id_on_create
      if defined?(current_user)
        @street_address.created_by_user_id = current_user.id
        @street_address.modified_by_user_id = current_user.id
      end
    end

    def assign_user_id_on_update
      @street_address.modified_by_user_id = current_user.id if defined?(current_user)
    end
end