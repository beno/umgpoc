class Party < ActiveRecord::Base
  include PartyModel::Partyable
  belongs_to  :user
  belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
  has_many    :party_opportunities, :dependent => :destroy
  has_many    :opportunities, :through => :party_opportunities, :uniq => true, :order => "opportunities.id DESC"
  has_many    :tasks, :as => :asset, :dependent => :destroy, :order => 'created_at DESC'
  has_many    :activities, :as => :subject, :order => 'created_at DESC'
  has_many    :emails, :as => :mediator

  scope :state, lambda { |filters|
    where('category IN (?)' + (filters.delete('other') ? ' OR category IS NULL' : ''), filters)
  }
  scope :created_by, lambda { |user| where(:user_id => user.id) }
  scope :assigned_to, lambda { |user| where(:assigned_to => user.id) }

  simple_column_search :name, :email, :match => :middle, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }
  uses_user_permissions
  acts_as_commentable
  paranoid
  exportable
  sortable :by => [ "name ASC", "rating DESC", "created_at DESC", "updated_at DESC" ], :default => "created_at DESC"

  validates_presence_of :name, :message => :missing_account_name
#  validates_uniqueness_of :name, :scope => :deleted_at
  validate :users_for_shared_access
  before_save :nullify_blank_category

  # Default values provided through class methods.
  #----------------------------------------------------------------------------
  def self.per_page ; 20     ; end
  def self.outline  ; "long" ; end

  # Extract last line of billing address and get rid of numeric zipcode.
  #----------------------------------------------------------------------------
  def location
    return "" unless self[:billing_address]
    location = self[:billing_address].strip.split("\n").last
    location.gsub(/(^|\s+)\d+(:?\s+|$)/, " ").strip if location
  end

  # Attach given attachment to the account if it hasn't been attached already.
  #----------------------------------------------------------------------------
  def attach!(attachment)
    unless self.send("#{attachment.class.name.downcase}_ids").include?(attachment.id)
      self.send(attachment.class.name.tableize) << attachment
    end
  end

  # Discard given attachment from the account.
  #----------------------------------------------------------------------------
  def discard!(attachment)
    if attachment.is_a?(Task)
      attachment.update_attribute(:asset, nil)
    else # Contacts, Opportunities
      self.send(attachment.class.name.tableize).delete(attachment)
    end
  end

  # Class methods.
  #----------------------------------------------------------------------------
  def self.create_or_select_for(model, params, users)
    if params[:id]
      account = Account.find(params[:id])
    else
      account = Account.new(params)
      if account.access != "Lead" || model.nil?
        account.save_with_permissions(users)
      else
        account.save_with_model_permissions(model)
      end
    end
    account
  end

  private
  # Make sure at least one user has been selected if the account is being shared.
  #----------------------------------------------------------------------------
  def users_for_shared_access
    errors.add(:access, :share_account) if self[:access] == "Shared" && !self.permissions.any?
  end

  def nullify_blank_category
    self.category = nil if self.category.blank?
  end

end
