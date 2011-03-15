module RemoteRecord::HasMany
  module ClassMethods
    def has_many_remote(association, association_key)

      collection = association.to_s
      member = association.to_s.singularize
      klass = Kernel.const_get member.classify

      # all
      # TODO: pagination
      define_method collection do
        inst_var = "@#{collection}" 
        return instance_variable_get(inst_var) if instance_variable_get(inst_var)
        instance_variable_set(inst_var, klass.all(self.send(association_key))) 
      end

      # first
      define_method member do |object_id|
        inst_var = "@#{member}_#{object_id.to_s}"
        return instance_variable_get(inst_var) if instance_variable_get(inst_var)
        instance_variable_set(inst_var, klass.first(object_id))
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end



# 
# def contracts
#   @contracts ||= Contract.legacy_items(legacy_id)
# end
# 
# def contract(id)
#   Contract.legacy_items(id, legacy_id)
# end
