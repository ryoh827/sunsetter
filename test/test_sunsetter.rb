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
  end

  def test_deprecated_field_warning
    _, err = capture_io do
      @model.name
    end
    assert_match(/warning: TestModel.name is deprecated./, err)
  end

  def test_non_deprecated_field_no_warning
    _, err = capture_io do
      @model.email
    end
    assert_empty err
  end

  def test_raises_error_when_used_in_non_mongoid_model
    error = assert_raises(RuntimeError) do
      NonMongoidModel.deprecate_field(:something)
    end
    assert_equal "Sunsetter can only be used in Mongoid::Document models", error.message
  end

  def test_include_order_does_not_matter
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
    assert_match(/warning: .*\.name is deprecated\./, err)
  end
end 
