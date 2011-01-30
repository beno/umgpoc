class LumberJackInternetAddressGenerator < Rails::Generator::Base
  # attr_accessor :migration_name, :migration_action
  def manifest
    record do |m|
      m.directory 'app/models'
      m.file 'app/models/internet_address.rb', 'app/models/internet_address.rb'
      m.directory 'app/controllers'
      m.file 'app/controllers/internet_addresses_controller.rb', 'app/controllers/internet_addresses_controller.rb'
      m.directory 'app/views'
      m.directory 'app/views/internet_addresses'
      m.file 'app/views/internet_addresses/_form.html.erb', "app/views/internet_addresses/_form.html.erb"
      m.file 'app/views/internet_addresses/_list.html.erb', "app/views/internet_addresses/_list.html.erb"
      m.file 'app/views/internet_addresses/_list_mini.html.erb', "app/views/internet_addresses/_list_mini.html.erb"
      m.file 'app/views/internet_addresses/_table.html.erb', "app/views/internet_addresses/_table.html.erb"
      m.file 'app/views/internet_addresses/edit.html.erb', "app/views/internet_addresses/edit.html.erb"
      m.file 'app/views/internet_addresses/index.html.erb', "app/views/internet_addresses/index.html.erb"
      m.file 'app/views/internet_addresses/new.html.erb', "app/views/internet_addresses/new.html.erb"
      m.file 'app/views/internet_addresses/show.html.erb', "app/views/internet_addresses/show.html.erb"
      m.file 'app/helpers/internet_addresses_helper.rb', 'app/helpers/internet_addresses_helper.rb'
      m.directory 'public'
      m.directory 'public/images'
      m.file 'public/images/add.png', 'public/images/add.png'
      m.file 'public/images/arrow_switch.png', 'public/images/arrow_switch.png'
      m.file 'public/images/credits.txt', 'public/images/credits.txt'
      m.file 'public/images/delete.png', 'public/images/delete.png'
      m.file 'public/images/page_add.png', 'public/images/page_add.png'
      m.file 'public/images/page_delete.png', 'public/images/page_delete.png'
      m.file 'public/images/page_edit.png', 'public/images/page_edit.png'
      m.file 'public/images/page_green.png', 'public/images/page_green.png'
      m.file 'public/images/page_link.png', 'public/images/page_link.png'
      m.file 'public/images/pencil.png', 'public/images/pencil.png'
      m.file 'public/images/spinner.gif', 'public/images/spinner.gif'
      m.directory 'public/stylesheets'
      m.file 'public/stylesheets/lumber_jack.css', 'public/stylesheets/lumber_jack.css'
      m.file 'public/stylesheets/scaffold.css', 'public/stylesheets/scaffold.css'
      m.migration_template 'db/migrate/create_internet_addresses.rb', "db/migrate", :migration_file_name => "create_internet_addresses"
      # m.route_name :sort_internet_addresses, 'internet_addresses/sort', :controller => 'internet_addresses', :action => 'sort', :method => :post
      # The line above did not work, so I did this instead:
      m.gsub_file 'config/routes.rb', /(#{Regexp.escape('ActionController::Routing::Routes.draw do |map|')})/mi do |match|
        "#{match}\n  map.sort_internet_addresses 'internet_addresses/sort', :controller => 'internet_addresses', :action => 'sort', :method => :post\n"
      end
      m.readme
    end
  end
end