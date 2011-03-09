module PartiesHelper
  
  def list_remote_objects(party, association)
    begin 
      render :partial => "parties/#{association.to_s.singularize}", :collection => party.send(association)
    rescue Exception => e
      "<span style='color:red'>Remote resource error: #{e}</span>".html_safe
    end
  end
  
end