require 'minitest/autorun'
require 'mongoid'
require_relative '../lib/sunsetter'

Mongoid.configure do |config|
  config.clients.default = {
    hosts: ['localhost:27017'],
    database: 'test_database'
  }
end

class TestModel
  include Mongoid::Document
  include Sunsetter

  field :name
  field :email
  deprecate_field :name
end

class NonMongoidModel
  include Sunsetter

  def self.deprecate_field(*args)
    super
  end
end

class TestSunsetter < Minitest::Test
  def setup
    @model = TestModel.new
    @original_logger = Sunsetter.logger
  end

  def teardown
    Sunsetter.logger = @original_logger
  end

  def test_deprecated_field_warning_with_default_logger
    _, err = capture_io do
      @model.name
    end
    assert_match(/\[SUNSETTER\] TestModel#name is deprecated and will be removed in a future version\./, err)
    assert_match(/\[SUNSETTER\] Called from: .*test_sunsetter\.rb:\d+.*/, err)
    assert_match(/\[SUNSETTER\] Please update your code to use alternative methods\./, err)
  end

  def test_deprecated_field_warning_with_custom_logger
    messages = []
    Sunsetter.logger = ->(message) { messages << message }
    
    @model.name
    
    assert_equal 3, messages.size
    assert_match(/\[SUNSETTER\] TestModel#name is deprecated and will be removed in a future version\./, messages[0])
    assert_match(/\[SUNSETTER\] Called from: .*test_sunsetter\.rb:\d+.*/, messages[1])
    assert_match(/\[SUNSETTER\] Please update your code to use alternative methods\./, messages[2])
  end

  def test_non_deprecated_field_no_warning_with_default_logger
    _, err = capture_io do
      @model.email
    end
    assert_empty err
  end

  def test_non_deprecated_field_no_warning_with_custom_logger
    messages = []
    Sunsetter.logger = ->(message) { messages << message }
    
    @model.email
    
    assert_empty messages
  end

  def test_raises_error_when_used_in_non_mongoid_model
    error = assert_raises(RuntimeError) do
      NonMongoidModel.deprecate_field(:something)
    end
    assert_equal "Sunsetter can only be used in Mongoid::Document models", error.message
  end

  def test_include_order_does_not_matter_with_default_logger
    klass = Class.new do
      include Sunsetter
      include Mongoid::Document

      field :name
      deprecate_field :name
    end

    model = klass.new
    _, err = capture_io do
      model.name
    end
    assert_match(/\[SUNSETTER\] .*#name is deprecated and will be removed in a future version\./, err)
    assert_match(/\[SUNSETTER\] Called from: .*test_sunsetter\.rb:\d+.*/, err)
    assert_match(/\[SUNSETTER\] Please update your code to use alternative methods\./, err)
  end

  def test_include_order_does_not_matter_with_custom_logger
    messages = []
    Sunsetter.logger = ->(message) { messages << message }

    klass = Class.new do
      include Sunsetter
      include Mongoid::Document

      field :name
      deprecate_field :name
    end

    model = klass.new
    model.name
    
    assert_equal 3, messages.size
    assert_match(/\[SUNSETTER\] .*#name is deprecated and will be removed in a future version\./, messages[0])
    assert_match(/\[SUNSETTER\] Called from: .*test_sunsetter\.rb:\d+.*/, messages[1])
    assert_match(/\[SUNSETTER\] Please update your code to use alternative methods\./, messages[2])
  end
end 
