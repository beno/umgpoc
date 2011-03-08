module NestedForm
  class Builder < ::ActionView::Helpers::FormBuilder
    def link_to_add(name, association, *args)
      @fields ||= {}
      options = args.last.is_a?(Hash) ? args.last : {}
      assoc_name = association_name(association, options)
      @template.after_nested_form(assoc_name) do
        model_object = object.class.reflect_on_association(association).klass.new(options)
        output = %Q[<div id="#{assoc_name}_fields_blueprint" style="display: none">].html_safe
        output << fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association])
        output.safe_concat('</div>')
        output
      end
      @template.link_to(name, "javascript:void(0)", :class => "add_nested_fields", "data-association" => assoc_name)
    end

    def link_to_remove(name)
      hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", :class => "remove_nested_fields")
    end

    def fields_for_with_nested_attributes(association, args, block)
      @fields ||= {}
      @fields[association] = block
      super
    end

    def fields_for_nested_model(name, association, args, block)
      output = '<div class="fields">'.html_safe
      output << super
      output.safe_concat('</div>')
      output
    end

    def association_name(association, options)
      options.empty? ? association : ([association, 'with'] << options.to_a.flatten).join('_')
    end
  end
end

