module NestedForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end
      
      def copy_jquery_file
        if File.exists?('public/javascripts/prototype.js')
          copy_file 'prototype_nested_form.js', 'public/javascripts/nested_form.js'
        else
          copy_file 'jquery_nested_form.js', 'public/javascripts/nested_form.js'
        end
      end
    end
  end
end
