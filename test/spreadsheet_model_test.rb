require 'test_helper'
require 'pry'

p "sheet: #{ENV['GOOGLE_DRIVE_TEST_MODEL_SHEET_KEY']}"
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

class AltModel
  include SpreadsheetModel
  attr_accessor :pwr
  SHEET_KEY = ENV['GOOGLE_DRIVE_TEST_MODEL_SHEET_KEY']
end

class ModelWithoutAccessor
  include SpreadsheetModel
  SHEET_KEY = ENV['GOOGLE_DRIVE_TEST_MODEL_SHEET_KEY']
end

class SpreadsheetModelTest < Minitest::Test
  def setup
    # HOW TO RUN TEST: Create spreasheet with following data
    # TestModel.create(id: 1, type: nil, value: 100)
    # TestModel.create(id: 2, type: 'TestModel::TypeA', value: 200, pwr: 2)
    # TestModel.create(id: 3, type: 'TestModel::TypeA', value: 300)
    # TestModel.create(id: 4, type: 'TestModel::TypeA', value: 400, pwr: 3)
    # TestModel.create(id: 3, type: 'TestModel::TypeA', value: 400, pwr: 3)
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
    assert_equal nil, TestModel.find(nil)
  end

  def test_that_it_can_hash_like_access
    assert_equal '100', TestModel.find(1)['value']
  end

  def test_that_it_has_a_single_table_inheritance_methods
    assert_equal 400, TestModel.find(2).double
  end

  def test_that_it_has_a_multiple_values
    assert_equal 3, TestModel.find([2, 3]).count
    assert_equal '300', TestModel.find([2, 3])[1].value
  end

  def test_that_it_can_recache_when_cache_is_cleared
    TestModel.find(1).value
    cache = TestModel.class_eval{ class_variable_get(:@@cache) }
    cache.clear
    assert_equal '100', TestModel.find(1).value
  end

  def test_that_it_can_import
    assert_equal 1, TestModel.find([1]).count
    assert_equal 1, ModelWithoutAccessor.find([1]).count
  end

  def test_that_it_can_define_sheet_key
    assert_equal '3', AltModel.find(4).pwr
  end

  def test_that_it_has_correct_columns
    assert_equal %w(id type value pwr), TestModel.column_names
    assert_equal %w(id type value pwr), AltModel.column_names
    assert_equal %w(id type value pwr), ModelWithoutAccessor.column_names
  end

  def test_that_it_has_all_ids
    assert 2 < TestModel.keys.count
    assert_match /\d+/, TestModel.keys.join('')
  end
end
