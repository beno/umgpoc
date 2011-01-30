class PartyRelationshipsController < ApplicationController
  layout 'application'
  
  # GET /relationships
  # GET /relationships.xml
  def index
    # @party_relationships = PartyRelationship.recent
    @party_relationships = PartyRelationship.find(:all, :order => 'position', :limit => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @party_relationships }
    end
  end

  # GET /relationships/1
  # GET /relationships/1.xml
  def show
    @party_relationship = PartyRelationship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @party_relationship }
    end
  end

  # GET /relationships/new
  # GET /relationships/new.xml
  def new
    @party_relationship = PartyRelationship.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @party_relationship }
    end
  end

  # GET /relationships/1/edit
  def edit
    @party_relationship = PartyRelationship.find(params[:id])
  end

  # POST /relationships
  # POST /relationships.xml
  def create
    @party_relationship = PartyRelationship.new(params[:party_relationship])

    respond_to do |format|
      if @party_relationship.save
        flash[:notice] = 'PartyRelationship was successfully created.'
        format.html { redirect_to(@party_relationship) }
        format.xml  { render :xml => @party_relationship, :status => :created, :location => @party_relationship }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @party_relationship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /relationships/1
  # PUT /relationships/1.xml
  def update
    @party_relationship = PartyRelationship.find(params[:id])

    respond_to do |format|
      if @party_relationship.update_attributes(params[:party_relationship])
        flash[:notice] = 'PartyRelationship was successfully updated.'
        format.html { redirect_to(@party_relationship) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @party_relationship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /relationships/1
  # DELETE /relationships/1.xml
  def destroy
    @party_relationship = PartyRelationship.find(params[:id])
    @party_relationship.destroy

    respond_to do |format|
      format.html { redirect_to(party_relationships_url) }
      format.xml  { head :ok }
    end
  end
  
  def sort
    params[:party_relationships].each_with_index do |id, index|
      PartyRelationship.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end
end
