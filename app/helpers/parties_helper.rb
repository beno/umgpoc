module PartiesHelper
  
  def list_remote_objects(association)
    begin
      render :partial => "remote_resources/#{association.to_s}"
    rescue Exception => e
      "<span style='color:red'>Remote resource error: #{e}</span>".html_safe
    end
  end
  
end