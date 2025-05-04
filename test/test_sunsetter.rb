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
  include Sunsetter
  include Mongoid::Document

  field :name
  field :email
  deprecate_field :name
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
end 
