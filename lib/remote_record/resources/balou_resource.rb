class RemoteRecord::Resources::BalouResource < ActiveResource::Base

  self.site = "http://localhost:3001/"

  def self.all(association_id, options = {})
    find(:all, :params => {:legacy_id => association_id}.merge(options))
  end
  
  def self.first(object_id, options = {})
    remote_key = self.class.to_s.downcase + '_id'
    find(:first, :params => {remote_key => object_id}.merge(options))
  end
  
  #dummy for gravatar
  def email
  end
  
end