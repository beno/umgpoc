class LumberJackEmailAddressGenerator < Rails::Generator::Base
  # attr_accessor :migration_name, :migration_action
  
  def manifest
    recorded_session = record do |m|
      m.file 'app/models/email_address.rb', 'app/models/email_address.rb'
      m.file 'app/controllers/email_addresses_controller.rb', 'app/controllers/email_addresses_controller.rb'
      m.directory 'app/views/email_addresses'
      m.file 'app/views/email_addresses/_form.html.erb', "app/views/email_addresses/_form.html.erb"
      m.file 'app/views/email_addresses/_list.html.erb', "app/views/email_addresses/_list.html.erb"
      m.file 'app/views/email_addresses/_table.html.erb', "app/views/email_addresses/_table.html.erb"
      m.file 'app/views/email_addresses/edit.html.erb', "app/views/email_addresses/edit.html.erb"
      m.file 'app/views/email_addresses/index.html.erb', "app/views/email_addresses/index.html.erb"
      m.file 'app/views/email_addresses/new.html.erb', "app/views/email_addresses/new.html.erb"
      m.file 'app/views/email_addresses/show.html.erb', "app/views/email_addresses/show.html.erb"
      m.file 'app/helpers/email_addresses_helper.rb', 'app/helpers/email_addresses_helper.rb'
      m.file 'public/images/arrow_switch.png', 'public/images/arrow_switch.png'
      m.file 'public/images/email.png', 'public/images/email.png'
      m.file 'public/images/email_add.png', 'public/images/email_add.png'
      m.file 'public/images/email_delete.png', 'public/images/email_delete.png'
      m.file 'public/images/email_edit.png', 'public/images/email_edit.png'
      m.file 'public/images/credits.txt', 'public/images/credits.txt'
      m.file 'public/stylesheets/lumber_jack.css', 'public/stylesheets/lumber_jack.css'
      m.migration_template 'db/migrate/create_email_addresses.rb', "db/migrate", :migration_file_name => "create_email_addresses"
      m.readme
    end
    
    action = $0.split("/")[1]
      case action
        when "generate"
          add_routes
        when 'destroy'
          drop_routes
      end # case    
    recorded_session
    end 

    protected
    def add_routes
      find_me = 'ActionController::Routing::Routes.draw do |map|'
      gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| "#{match}\n  map.sort_email_addresses 'email_addresses/sort', :controller => 'email_addresses', :action => 'sort', :method => :post"}
    end

    def drop_routes
      find_me = "    map.sort_telephones 'email_addresses/sort', :controller => 'email_addresses', :action => 'sort', :method => :post\n"
      gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| ''}    
    end

    def gsub_file(relative_destination, regexp, *args, &block)
        path = destination_path(relative_destination)
        content = File.read(path).gsub(regexp, *args, &block)
        File.open(path, 'wb') { |file| file.write(content) }
    end
  end