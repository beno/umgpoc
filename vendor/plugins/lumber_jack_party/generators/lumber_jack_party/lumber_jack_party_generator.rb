class LumberJackPartyGenerator < Rails::Generator::Base
  def manifest
    recorded_session = record do |m|
      # m.directory "lib"
      # m.template 'README', "README"
      m.directory 'app/controllers'
      m.file 'app/controllers/parties_controller.rb', 'app/controllers/parties_controller.rb'
      m.file 'app/controllers/organizations_controller.rb', 'app/controllers/organizations_controller.rb'
      m.file 'app/controllers/people_controller.rb', 'app/controllers/people_controller.rb'
      m.directory 'app/helpers'
      m.file 'app/helpers/parties_helper.rb', 'app/helpers/parties_helper.rb'
      m.file 'app/helpers/organizations_helper.rb', 'app/helpers/organizations_helper.rb'
      m.file 'app/helpers/people_helper.rb', 'app/helpers/people_helper.rb'
      m.directory 'app/models'
      m.file 'app/models/party.rb', 'app/models/party.rb'
      m.file 'app/models/organization.rb', 'app/models/organization.rb'
      m.file 'app/models/person.rb', 'app/models/person.rb'
      m.directory 'app/views'
      m.directory 'app/views/parties'
      m.file 'app/views/parties/_form.html.erb', 'app/views/parties/_form.html.erb'
      m.file 'app/views/parties/_list.html.erb', 'app/views/parties/_list.html.erb'
      m.file 'app/views/parties/_nav_ancestors.html.erb', 'app/views/parties/_nav_ancestors.html.erb'
      m.file 'app/views/parties/_nav_children.html.erb', 'app/views/parties/_nav_children.html.erb'
      m.file 'app/views/parties/edit.html.erb', 'app/views/parties/edit.html.erb'
      m.file 'app/views/parties/index.html.erb', 'app/views/parties/index.html.erb'
      m.file 'app/views/parties/new.html.erb', 'app/views/parties/new.html.erb'
      m.file 'app/views/parties/show.html.erb', 'app/views/parties/show.html.erb'
      m.directory 'app/views/people'
      m.file 'app/views/people/_form.html.erb', 'app/views/people/_form.html.erb'
      m.file 'app/views/people/_list.html.erb', 'app/views/people/_list.html.erb'
      m.file 'app/views/people/_nav_ancestors.html.erb', 'app/views/people/_nav_ancestors.html.erb'
      m.file 'app/views/people/_nav_children.html.erb', 'app/views/people/_nav_children.html.erb'
      m.file 'app/views/people/edit.html.erb', 'app/views/people/edit.html.erb'
      m.file 'app/views/people/index.html.erb', 'app/views/people/index.html.erb'
      m.file 'app/views/people/new.html.erb', 'app/views/people/new.html.erb'
      m.file 'app/views/people/show.html.erb', 'app/views/people/show.html.erb' 
      m.directory 'app/views/organizations'
      m.file 'app/views/organizations/_form.html.erb', 'app/views/organizations/_form.html.erb'
      m.file 'app/views/organizations/_list.html.erb', 'app/views/organizations/_list.html.erb'
      m.file 'app/views/organizations/_nav_ancestors.html.erb', 'app/views/organizations/_nav_ancestors.html.erb'
      m.file 'app/views/organizations/_nav_children.html.erb', 'app/views/organizations/_nav_children.html.erb'
      m.file 'app/views/organizations/edit.html.erb', 'app/views/organizations/edit.html.erb'
      m.file 'app/views/organizations/index.html.erb', 'app/views/organizations/index.html.erb'
      m.file 'app/views/organizations/new.html.erb', 'app/views/organizations/new.html.erb'
      m.file 'app/views/organizations/show.html.erb', 'app/views/organizations/show.html.erb'
      m.directory 'test'
      m.directory 'test/fixtures'
      m.file 'test/fixtures/parties.yml', 'test/fixtures/parties.yml'
      m.directory 'test/functional'
      m.file 'test/functional/parties_controller_test.rb', 'test/functional/parties_controller_test.rb'
      m.directory 'test/performance'
      m.file 'test/performance/browsing_test.rb', 'test/performance/browsing_test.rb'
      m.directory 'test/unit'
      m.file 'test/unit/party_test.rb', 'test/unit/party_test.rb'
      m.directory 'test/unit/helpers'
      m.file 'test/unit/helpers/parties_helper_test.rb', 'test/unit/helpers/parties_helper_test.rb'
      m.directory 'public'
      m.directory 'public/images'
      m.file 'public/images/add.png', 'public/images/add.png'
      m.file 'public/images/arrow_switch.png', 'public/images/arrow_switch.png'
      m.file 'public/images/credits.txt', 'public/images/credits.txt'
      m.file 'public/images/delete.png', 'public/images/delete.png'
      m.file 'public/images/pencil.png', 'public/images/pencil.png'
      m.file 'public/images/spinner.gif', 'public/images/spinner.gif'
      m.directory 'public/stylesheets'
      m.file 'public/stylesheets/scaffold.css', 'public/stylesheets/scaffold.css'
      m.file 'public/stylesheets/lumber_jack.css', 'public/stylesheets/lumber_jack.css'
      m.migration_template 'db/migrate/create_parties.rb', "db/migrate",
        :migration_file_name => "create_parties"
    end # record
    
    action = $0.split("/")[1]
    case action
      when "generate"
        add_routes
      when 'destroy'
        drop_routes
    end # case
    
    recorded_session
     end # def manifest
     
    protected
      def add_routes
        find_me = 'ActionController::Routing::Routes.draw do |map|'
        gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| "#{match}\n  map.resources :parties, :collection => {:sort => :post}"}
        gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| "#{match}\n  map.resources :organizations, :collection => {:sort => :post}"}
        gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| "#{match}\n  map.resources :people, :collection => {:sort => :post}"}
      end
      
      def drop_routes
        find_me = "  map.resources :parties, :collection => {:sort => :post}\n"
        gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| ''}
        find_me = "  map.resources :organizations, :collection => {:sort => :post}\n"
        gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| ''}
        find_me = "  map.resources :people, :collection => {:sort => :post}\n"
        gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| ''}
      end
      
      def gsub_file(relative_destination, regexp, *args, &block)
        path = destination_path(relative_destination)
        content = File.read(path).gsub(regexp, *args, &block)
        File.open(path, 'wb') { |file| file.write(content) }
      end
end # class
