module RemoteResources
  module HasMany
    module ClassMethods
      def has_many_remote(association, foreign_key = :remote_id)
        define_method association do
          inst_var = "@" + association.to_s
          return instance_variable_get(inst_var) if instance_variable_get(inst_var)
          klass = Kernel.const_get(association.to_s.classify)
          instance_variable_set(inst_var, klass.remote_items(self.send(foreign_key))) 
        end
        
        define_method association.to_s.singularize do |remote_id|
          inst_var = "@" + association.to_s.singularize
          return instance_variable_get(inst_var) if instance_variable_get(inst_var)
          klass = Kernel.const_get(association.to_s.classify)
          instance_variable_set(inst_var, klass.remote_items(remote_id, self.send(foreign_key)))
        end
      end
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
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
