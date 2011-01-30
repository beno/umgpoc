class LumberJackPartyRelationshipGenerator < Rails::Generator::Base
  def manifest
    recorded_session = record do |m|
      # m.directory "lib"
      # m.template 'README', "README"
      m.directory 'app/controllers'
      m.file 'app/controllers/party_relationships_controller.rb', 'app/controllers/party_relationships_controller.rb'
      m.file 'app/controllers/contacts_controller.rb', 'app/controllers/contacts_controller.rb'
      m.directory 'app/helpers'
      m.file 'app/helpers/party_relationships_helper.rb', 'app/helpers/party_relationships_helper.rb'
      m.file 'app/helpers/contacts_helper.rb', 'app/helpers/contacts_helper.rb'
      m.directory 'app/models'
      m.file 'app/models/party_relationship.rb', 'app/models/party_relationship.rb'
      m.file 'app/models/contact.rb', 'app/models/contact.rb'
      m.directory 'app/views'
      m.directory 'app/views/party_relationships'
      m.file 'app/views/party_relationships/_form.html.erb', 'app/views/party_relationships/_form.html.erb'
      m.file 'app/views/party_relationships/_list.html.erb', 'app/views/party_relationships/_list.html.erb'
      m.file 'app/views/party_relationships/edit.html.erb', 'app/views/party_relationships/edit.html.erb'
      m.file 'app/views/party_relationships/index.html.erb', 'app/views/party_relationships/index.html.erb'
      m.file 'app/views/party_relationships/new.html.erb', 'app/views/party_relationships/new.html.erb'
      m.file 'app/views/party_relationships/show.html.erb', 'app/views/party_relationships/show.html.erb'
      m.directory 'app/views/contacts'
      m.file 'app/views/contacts/_form.html.erb', 'app/views/contacts/_form.html.erb'
      m.file 'app/views/contacts/_list.html.erb', 'app/views/contacts/_list.html.erb'
      m.file 'app/views/contacts/edit.html.erb', 'app/views/contacts/edit.html.erb'
      m.file 'app/views/contacts/index.html.erb', 'app/views/contacts/index.html.erb'
      m.file 'app/views/contacts/new.html.erb', 'app/views/contacts/new.html.erb'
      m.file 'app/views/contacts/show.html.erb', 'app/views/contacts/show.html.erb'
      m.directory 'test'
      m.directory 'test/fixtures'
      m.file 'test/fixtures/party_relationships.yml', 'test/fixtures/party_relationships.yml'
      m.file 'test/fixtures/contacts.yml', 'test/fixtures/contacts.yml'
      m.directory 'test/functional'
      m.file 'test/functional/party_relationships_controller_test.rb', 'test/functional/party_relationships_controller_test.rb'
      m.file 'test/functional/contacts_controller_test.rb', 'test/functional/contacts_controller_test.rb'
      m.directory 'test/performance'
      m.file 'test/performance/browsing_test.rb', 'test/performance/browsing_test.rb'
      m.directory 'test/unit'
      m.file 'test/unit/party_relationship_test.rb', 'test/unit/party_relationship_test.rb'
      m.file 'test/unit/contact_test.rb', 'test/unit/contact_test.rb'
      m.directory 'test/unit/helpers'
      m.file 'test/unit/helpers/party_relationships_helper_test.rb', 'test/unit/helpers/party_relationships_helper_test.rb'
      m.file 'test/unit/helpers/contacts_helper_test.rb', 'test/unit/helpers/contacts_helper_test.rb'
      m.directory 'public'
      m.directory 'public/images'
      m.file 'public/images/add.png', 'public/images/add.png'
      m.file 'public/images/arrow_switch.png', 'public/images/arrow_switch.png'
      m.file 'public/images/credits.txt', 'public/images/credits.txt'
      m.file 'public/images/delete.png', 'public/images/delete.png'
      m.file 'public/images/pencil.png', 'public/images/pencil.png'
      m.file 'public/images/spinner.png', 'public/images/spinner.png'
      m.directory 'public/stylesheets'
      m.file 'public/stylesheets/lumber_jack.css', 'public/stylesheets/lumber_jack.css'
      m.file 'public/stylesheets/scaffold.css', 'public/stylesheets/scaffold.css'
      
      m.migration_template 'db/migrate/create_party_relationships.rb', "db/migrate",
        :migration_file_name => "create_party_relationships"
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
        gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| "#{match}\n  map.resources :party_relationships, :collection => {:sort => :post}"}
        gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| "#{match}\n  map.resources :contacts, :collection => {:sort => :post}"}
      end
      
      def drop_routes
        find_me = "  map.resources :party_relationships, :collection => {:sort => :post}\n"
        gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| ''}
        find_me = "  map.resources :contacts, :collection => {:sort => :post}\n"
        gsub_file('config/routes.rb', /(#{Regexp.escape(find_me)})/mi){|match| ''}
      end
      
      def gsub_file(relative_destination, regexp, *args, &block)
        path = destination_path(relative_destination)
        content = File.read(path).gsub(regexp, *args, &block)
        File.open(path, 'wb') { |file| file.write(content) }
      end
end # class
