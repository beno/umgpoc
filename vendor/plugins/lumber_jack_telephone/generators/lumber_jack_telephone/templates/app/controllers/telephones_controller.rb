# Assumes that Telephones will always be accessed from a parent controller.
# In views, use polymorphic path helpers: polymorphic_url([@telephonic, telephone])
#
# Note the before_filter, and the comments below, for :find_telephonic.
class TelephonesController < ApplicationController
  before_filter :find_telephonic
  
  # GET /telephones
  # GET /telephones.xml
  def index
    @telephones = @telephonic.telephones
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @telephones }
    end
  end

  # GET /telephones/1
  # GET /telephones/1.xml
  def show
    @telephone = @telephonic.telephones.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @telephone }
    end
  end

  # GET /telephones/new
  # GET /telephones/new.xml
  def new
    @telephone = @telephonic.telephones.new
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @telephone }
    end
  end

  # GET /telephones/1/edit
  def edit
    @telephone = @telephonic.telephones.find(params[:id])
  end

  # POST /telephones
  # POST /telephones.xml
  def create
    @telephone = @telephonic.telephones.new(params[:telephone])
    assign_user_id_on_create
    respond_to do |format|
      if @telephone.save
        flash[:notice] = 'Telephone was successfully created.'
        format.html { redirect_to(@telephone.telephonic) }
        format.xml  { render :xml => @telephone, :status => :created, :location => @telephone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @telephone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /telephones/1
  # PUT /telephones/1.xml
  def update
    @telephone = @telephonic.telephones.find(params[:id])
    assign_user_id_on_update
    respond_to do |format|
      if @telephone.update_attributes(params[:telephone])
        flash[:notice] = 'Telephone was successfully updated.'
        format.html { redirect_to(@telephone.telephonic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @telephone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /telephones/1
  # DELETE /telephones/1.xml
  def destroy
    @telephone = @telephonic.telephones.find(params[:id])
    @telephone.destroy
    
    respond_to do |format|
      format.html { redirect_to(@telephonic) }
      format.xml  { head :ok }
    end
  end

  # sort is used to support the AJAX drag and drop sorting in _list.html.erb. 
  # It updates the position column to reflect the new sort order.
  # POST /telephones/1/sort
  # POST /telephones/sort.xml
  def sort
    params[:telephones].each_with_index do |id, index|
      Telephone.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

  private
    # find_telephonic will look at the params to identify a model_id. It will then
    # use a little Ruby magic to find the class for that Model, instantiate it, and 
    # use Model.find(:id) to find the proper telephone. Users will not be able to 
    # hack the URL to find Telephones not belonging to the current 'model'
    def find_telephonic
      @telephonic = nil
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @telephonic = $1.classify.constantize.find(value)
        end
      end
      @telephonic
    end
    
    # Assumes that your security system uses 'current_user' to identify the 
    # current user. You can change this to match your current user convention.
    def assign_user_id_on_create
      if defined?(current_user)
        @telephone.created_by_user_id = current_user.id
        @telephone.modified_by_user_id = current_user.id
      end
    end

    # Assumes that your security system uses 'current_user' to identify the 
    # current user. You can change this to match your current user convention.
    def assign_user_id_on_update
      @telephone.modified_by_user_id = current_user.id if defined?(current_user)
    end
end