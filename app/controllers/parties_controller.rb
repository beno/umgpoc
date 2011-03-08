# Fat Free CRM
# Copyright (C) 2008-2010 by Michael Dvorkin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------------------------------------------------------

class PartiesController < ApplicationController
  before_filter :require_user
  before_filter :get_data_for_sidebar, :only => :index
  before_filter :set_current_tab, :only => [ :index, :show ]
  after_filter  :update_recently_viewed, :only => :show

  # GET /parties
  # GET /parties.xml                                             HTML and AJAX
  #----------------------------------------------------------------------------
  def index
    @parties = get_parties(:page => params[:page])

    respond_to do |format|
      format.html # index.html.haml
      format.js   # index.js.rjs
      format.xml  { render :xml => @parties }
      format.xls  { send_data @parties.to_xls, :type => :xls }
      format.csv  { send_data @parties.to_csv, :type => :csv }
      format.rss  { render "common/index.rss.builder" }
      format.atom { render "common/index.atom.builder" }
    end
  end

  # GET /parties/1
  # GET /parties/1.xml                                                    HTML
  #----------------------------------------------------------------------------
  def show
    @party = get_klass.my.find(params[:id])
    @stage = Setting.unroll(:opportunity_stage)
    @comment = Comment.new

    @timeline = Timeline.find(@party)

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @party }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:html, :xml)
  end

  # GET /parties/new
  # GET /parties/new.xml                                                  AJAX
  #----------------------------------------------------------------------------
  def new
    @party = get_klass.new(:user => @current_user, :access => Setting.default_access)
    @users = User.except(@current_user)
    if params[:related]
      model, id = params[:related].split("_")
      instance_variable_set("@#{model}", model.classify.constantize.find(id))
    end

    respond_to do |format|
      format.js   # new.js.rjs
      format.xml  { render :xml => @party }
    end
  end

  # GET /parties/1/edit                                                   AJAX
  #----------------------------------------------------------------------------
  def edit
    @party = get_klass.my.find(params[:id])
    @users = User.except(@current_user)
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Party.my.find($1)
    end

  rescue ActiveRecord::RecordNotFound
    @previous ||= $1.to_i
    respond_to_not_found(:js) unless @party
  end

  # POST /parties
  # POST /parties.xml                                                     AJAX
  #----------------------------------------------------------------------------
  def create
    @party = get_klass.new(params[get_sym])
    @users = User.except(@current_user)

    respond_to do |format|
      if @party.save_with_permissions(params[:users])
        # None: client can only be created from the Accounts index page, so we
        # don't have to check whether we're on the index page.
        @parties = get_parties
        get_data_for_sidebar
        format.js   # create.js.rjs
        format.xml  { render :xml => @party, :status => :created, :location => @party }
      else
        format.js   # create.js.rjs
        format.xml  { render :xml => @party.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /parties/1
  # PUT /parties/1.xml                                                    AJAX
  #----------------------------------------------------------------------------
  def update
    @party = get_klass.my.find(params[:id])

    respond_to do |format|
      if @party.update_with_permissions(params[get_sym], params[:users])
        get_data_for_sidebar
        format.js
        format.xml  { head :ok }
      else
        @users = User.except(@current_user) # Need it to redraw [Edit Party] form.
        format.js
        format.xml  { render :xml => @party.errors, :status => :unprocessable_entity }
      end
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  # DELETE /parties/1
  # DELETE /parties/1.xml                                        HTML and AJAX
  #----------------------------------------------------------------------------
  def destroy
    @party = get_klass.my.find(params[:id])
    @party.destroy if @party

    respond_to do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
      format.xml  { head :ok }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:html, :js, :xml)
  end

  # GET /parties/search/query                                             AJAX
  #----------------------------------------------------------------------------
  def search
    @parties = get_parties(:query => params[:query], :page => 1)

    respond_to do |format|
      format.js   { render :index }
      format.xml  { render :xml => @parties.to_xml }
    end
  end

  # PUT /parties/1/attach
  # PUT /parties/1/attach.xml                                             AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :attach

  # PUT /parties/1/discard
  # PUT /parties/1/discard.xml                                            AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :discard

  # POST /parties/auto_complete/query                                     AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /parties/options                                                  AJAX
  #----------------------------------------------------------------------------
  def options
    unless params[:cancel].true?
      @per_page = @current_user.pref[:parties_per_page] || Party.per_page
      @outline  = @current_user.pref[:parties_outline]  || Party.outline
      @sort_by  = @current_user.pref[:parties_sort_by]  || Party.sort_by
    end
  end

  # POST /parties/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    @current_user.pref[:parties_per_page] = params[:per_page] if params[:per_page]
    @current_user.pref[:parties_outline]  = params[:outline]  if params[:outline]
    @current_user.pref[:parties_sort_by]  = Party::sort_by_map[params[:sort_by]] if params[:sort_by]
    @parties = get_parties(:page => 1)
    render :index
  end

  # POST /parties/filter                                                  AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:filter_by_party_category] = params[:category]
    @parties = get_parties(:page => 1)
    render :index
  end

  private
  #----------------------------------------------------------------------------
  def get_parties(options = {})
    get_list_of_records(get_klass, options.merge!(:filter => :filter_by_party_category))
  end

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @parties = get_parties
      get_data_for_sidebar
      if @parties.blank?
        @parties = get_parties(:page => current_page - 1) if current_page > 1
        render :index and return
      end
      # At this point render default destroy.js.rjs template.
    else # :html request
      self.current_page = 1 # Reset current page to 1 to make sure it stays valid.
      flash[:notice] = "#{t(:asset_deleted, @party.name)}"
      redirect_to parties_path
    end
  end

  #----------------------------------------------------------------------------
  def get_data_for_sidebar
    @party_category_total = Hash[
      Setting.party_category.map do |key|
        [ key, get_klass.my.where(:category => key.to_s).count ]
      end
    ]
    categorized = @party_category_total.values.sum
    @party_category_total[:all] = get_klass.my.count
    @party_category_total[:other] = @party_category_total[:all] - categorized
  end

  def get_klass
    @klass ||= self.controller_name.singularize.camelize.constantize
  end

  def get_sym
    @sym ||= self.controller_name.singularize.to_sym
  end

end
