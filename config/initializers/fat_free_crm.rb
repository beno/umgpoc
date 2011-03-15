require "fat_free_crm"
require "party_model"
require "remote_record"

#---------------------------------------------------------------------
Sass::Plugin.options[:template_location] = File.join(Rails.root, "app/stylesheets")
Sass::Plugin.options[:css_location] = File.join(Rails.root, "public/stylesheets")

#---------------------------------------------------------------------
WillPaginate::ViewHelpers.pagination_options[:renderer] = "AjaxWillPaginate"
