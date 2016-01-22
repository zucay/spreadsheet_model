require 'test_helper'

class SpreadsheetModelTest < Minitest::Test

  class TestModel
    include SpreadsheetModel
  end

  class TestModel::TypeA < TestModel
    def double
      value.to_i * 2
    end
  end

  def setup
    # TODO Create Table: id/type/value
    # TODO TestModel.create(id: 1, type: nil, value: 100)
    # TODO TestModel.create(id: 2, type: 'TestModel::TypeA', value: 200)
  end


  def test_that_it_has_a_version_number
    refute_nil ::SpreadsheetModel::VERSION
  end

  def test_that_it_has_a_find_method
    assert_equal '100', TestModel.find(1)['value']
    assert_equal '200', TestModel.find(2)['value']
  end

  def test_that_it_has_a_instance_method
    asset_equal '100', TestModel.find(1).value
  end

  def test_that_it_has_a_single_table_inheritance_methods
    asset_equal 400, TestModel.find(2).double
  end

end
