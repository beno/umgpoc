class LumberJackTelephoneGenerator < Rails::Generator::Base
  
  def manifest
    recorded_session = record do |m|
      m.directory 'app/models'
      m.file 'app/models/telephone.rb', 'app/models/telephone.rb'
      m.directory 'app/controllers'
      m.file 'app/controllers/telephones_controller.rb', 'app/controllers/telephones_controller.rb'
      m.directory 'app/views/telephones'
      m.file 'app/views/telephones/_form.html.erb', "app/views/telephones/_form.html.erb"
      m.file 'app/views/telephones/_list.html.erb', "app/views/telephones/_list.html.erb"
      m.file 'app/views/telephones/_list_mini.html.erb', "app/views/telephones/_list_mini.html.erb"
      m.file 'app/views/telephones/edit.html.erb', "app/views/telephones/edit.html.erb"
      m.file 'app/views/telephones/index.html.erb', "app/views/telephones/index.html.erb"
      m.file 'app/views/telephones/new.html.erb', "app/views/telephones/new.html.erb"
      m.file 'app/views/telephones/show.html.erb', "app/views/telephones/show.html.erb"
      m.directory 'app/helpers'
      m.file 'app/helpers/telephones_helper.rb', 'app/helpers/telephones_helper.rb'
      m.directory 'public'
      m.directory 'public/images'
      m.file 'public/images/add.png', 'public/images/add.png'
      m.file 'public/images/arrow_switch.png', 'public/images/arrow_switch.png'
      m.file 'public/images/credits.txt', 'public/images/credits.txt'
      m.file 'public/images/delete.png', 'public/images/delete.png'
      m.file 'public/images/pencil.png', 'public/images/pencil.png'
      m.file 'public/images/spinner.gif', 'public/images/spinner.gif'
      m.file 'public/images/telephone.png', 'public/images/telephone.png'
      m.file 'public/images/telephone_add.png', 'public/images/telephone_add.png'
      m.file 'public/images/telephone_delete.png', 'public/images/telephone_delete.png'
      m.file 'public/images/telephone_edit.png', 'public/images/telephone_edit.png'
      m.directory 'public/stylesheets'      
      m.file 'public/stylesheets/lumber_jack.css', 'public/stylesheets/lumber_jack.css'
      m.file 'public/stylesheets/scaffold.css', 'public/stylesheets/scaffold.css'
      m.directory 'test'
      m.directory 'test/fixtures'
      m.file 'test/fixtures/telephones.yml', 'test/fixtures/telephones.yml'
      m.directory 'test/functional'
      m.file 'test/functional/telephones_controller_test.rb', 'test/functional/telephones_controller_test.rb'
      m.directory 'test/performance'
      m.file 'test/performance/browsing_test.rb', 'test/performance/browsing_test.rb'
      m.directory 'test/unit'
      m.file 'test/unit/telephone_test.rb', 'test/unit/telephone_test.rb'
      m.directory 'test/unit/helpers'
      m.file 'test/unit/helpers/telephones_helper_test.rb', 'test/unit/helpers/telephones_helper_test.rb'
      m.migration_template 'db/migrate/create_telephones.rb', "db/migrate", :migration_file_name => "create_telephones"    
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
    gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| "#{match}\n  map.sort_telephones 'telephones/sort', :controller => 'telephones', :action => 'sort', :method => :post"}
  end
  
  def drop_routes
    find_me = "    map.sort_telephones 'telephones/sort', :controller => 'telephones', :action => 'sort', :method => :post\n"
    gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| ''}    
  end
  
  def gsub_file(relative_destination, regexp, *args, &block)
      path = destination_path(relative_destination)
      content = File.read(path).gsub(regexp, *args, &block)
      File.open(path, 'wb') { |file| file.write(content) }
  end
end