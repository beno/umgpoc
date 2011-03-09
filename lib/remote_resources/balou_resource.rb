class RemoteResources::BalouResource < ActiveResource::Base

  self.site = "http://localhost:3001/"

  def self.remote_items(scope = :all, legacy_id)
    find(scope, :params => {:legacy_id => legacy_id})
  end
  
  #dummy for gravatar
  def email
  end
  
end