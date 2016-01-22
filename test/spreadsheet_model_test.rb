require 'test_helper'

class TestModel
  include SpreadsheetModel
  attr_accessor :id, :type, :value
  def initialize(attributes={})
    super
    @omg ||= true
  end
end

class TestModel::TypeA < TestModel
  def double
    value.to_i * 2
  end
end

class SpreadsheetModelTest < Minitest::Test

  def setup
    # TODO Create Table: id/type/value
    # TODO TestModel.create(id: 1, type: nil, value: 100)
    # TODO TestModel.create(id: 2, type: 'TestModel::TypeA', value: 200)
  end


  def test_that_it_has_a_version_number
    refute_nil ::SpreadsheetModel::VERSION
  end

  def test_that_it_can_initialize
    assert_equal TestModel, TestModel.new(id: 1, type: nil, value: 100).class
    assert_equal TestModel, TestModel.new('id' => '1', 'type' => nil, 'value' => 100).class
  end

  def test_that_it_has_a_find_method
    assert_equal '100', TestModel.find(1).value
    assert_equal '200', TestModel.find(2).value
  end

  def test_that_it_returns_nil_when_record_not_found
    assert_equal nil, TestModel.find('foobar')
  end

  def test_that_it_can_hash_like_access
    assert_equal '100', TestModel.find(1)['value']
  end

  def test_that_it_has_a_single_table_inheritance_methods
    assert_equal 400, TestModel.find(2).double
  end
end
