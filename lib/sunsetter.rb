module Sunsetter
  class << self
    attr_accessor :logger

    def configure
      yield self
    end
  end

  # デフォルトのロガー
  self.logger = ->(message) { warn message }

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
          caller_info = caller(1..1).first
          Sunsetter.logger.call("[SUNSETTER] #{self.class.name}##{field_name} is deprecated and will be removed in a future version.")
          Sunsetter.logger.call("[SUNSETTER] Called from: #{caller_info}")
          Sunsetter.logger.call("[SUNSETTER] Please update your code to use alternative methods.")
          original_method.bind_call(self, *args, &block)
        end
      end
    end
  end
end
