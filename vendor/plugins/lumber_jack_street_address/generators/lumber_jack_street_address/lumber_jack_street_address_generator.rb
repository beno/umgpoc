class LumberJackStreetAddressGenerator < Rails::Generator::Base
  def manifest
    recorded_session = record do |m|
      m.directory 'app'
      m.directory 'app/models'
      m.file 'app/models/street_address.rb', 'app/models/street_address.rb'
      m.directory 'app/controllers'
      m.file 'app/controllers/street_addresses_controller.rb', 'app/controllers/street_addresses_controller.rb'
      m.directory 'app/views'
      m.directory 'app/views/street_addresses'
      m.file 'app/views/street_addresses/_form.html.erb', "app/views/street_addresses/_form.html.erb"
      m.file 'app/views/street_addresses/_list.html.erb', "app/views/street_addresses/_list.html.erb"
      m.file 'app/views/street_addresses/_list_mini.html.erb', "app/views/street_addresses/_list_mini.html.erb"
      m.file 'app/views/street_addresses/_table.html.erb', "app/views/street_addresses/_table.html.erb"
      m.file 'app/views/street_addresses/edit.html.erb', "app/views/street_addresses/edit.html.erb"
      m.file 'app/views/street_addresses/index.html.erb', "app/views/street_addresses/index.html.erb"
      m.file 'app/views/street_addresses/new.html.erb', "app/views/street_addresses/new.html.erb"
      m.file 'app/views/street_addresses/show.html.erb', "app/views/street_addresses/show.html.erb"
      m.directory 'app/helpers'
      m.file 'app/helpers/street_addresses_helper.rb', 'app/helpers/street_addresses_helper.rb'
      m.file 'config/initializers/geokit_config.rb', 'config/initializers/geokit_config.rb'
      m.file 'public/images/add.png', 'public/images/add.png'
      m.file 'public/images/arrow_switch.png', 'public/images/arrow_switch.png'
      m.file 'public/images/credits.txt', 'public/images/credits.txt'
      m.file 'public/images/delete.png', 'public/images/delete.png'
      m.file 'public/images/pencil.png', 'public/images/pencil.png'
      m.file 'public/images/spinner.gif', 'public/images/spinner.gif'
      m.file 'public/images/world.png', 'public/images/world.png'
      m.file 'public/images/world_add.png', 'public/images/world_add.png'
      m.file 'public/images/world_delete.png', 'public/images/world_delete.png'
      m.file 'public/images/world_edit.png', 'public/images/world_edit.png'
      m.file 'public/stylesheets/lumber_jack.css', 'public/stylesheets/lumber_jack.css'
      m.file 'public/stylesheets/scaffold.css', 'public/stylesheets/scaffold.css'
      m.migration_template 'db/migrate/create_street_addresses.rb', "db/migrate", :migration_file_name => "create_street_addresses"
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
      gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| "#{match}\n  map.sort_street_addresses 'street_addresses/sort', :controller => 'street_addresses', :action => 'sort', :method => :post"}
    end
    
    def drop_routes
      find_me = "  map.sort_street_addresses 'street_addresses/sort', :controller => 'street_addresses', :action => 'sort', :method => :post\n"
      gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| ''}
    end
    
    def gsub_file(relative_destination, regexp, *args, &block)
      path = destination_path(relative_destination)
      content = File.read(path).gsub(regexp, *args, &block)
      File.open(path, 'wb') { |file| file.write(content) }
    end
end