module Sunsetter
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def deprecate_field(*field_names)
      unless include?(Mongoid::Document)
        raise "Sunsetter can only be used in Mongoid::Document models"
      end

      field_names.each do |field_name|
        original_method = instance_method(field_name)
        
        define_method(field_name) do |*args, &block|
          caller_info = caller.first
          warn "[SUNSETTER] #{self.class.name}##{field_name} is deprecated and will be removed in a future version."
          warn "[SUNSETTER] Called from: #{caller_info}"
          warn "[SUNSETTER] Please update your code to use alternative methods."
          original_method.bind(self).call(*args, &block)
        end
      end
    end
  end
end 
