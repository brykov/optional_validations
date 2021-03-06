require 'minitest/autorun'
require 'optional_validations'

class ModelBase
  include ActiveModel::Validations

  attr_accessor :attr1, :attr2, :attr3

  def test1?
    true
  end

  def test2?
    true
  end

  def self.name
    'ModelExample'
  end

end


class OptionalValidationsTest < Minitest::Test
  def test_valid_by_default
    model = Class.new(ModelBase) do
      # validates_presence_of :attr1
    end
    m = model.new
    assert m.valid?
  end


  def test_basic_validation
    model = Class.new(ModelBase) do
      validates_presence_of :attr1
    end
    m = model.new
    assert !m.valid?
  end

  def test_basic_validate_only
    model = Class.new(ModelBase) do
      validates_presence_of :attr1
    end
    m = model.new
    assert !m.valid?

    m.validate_only :attr2 do
      assert m.valid?
    end
    assert !m.valid?

    m.validate_only :attr1 do
      assert !m.valid?
    end
    assert !m.valid?
  end

  def test_basic_validate_except
    model = Class.new(ModelBase) do
      validates_presence_of :attr1
    end
    m = model.new
    assert !m.valid?

    m.validate_except :attr2 do
      assert !m.valid?
    end
    assert !m.valid?

    m.validate_except :attr1 do
      assert m.valid?
    end
    assert !m.valid?
  end


  def test_multiple_fields
    model = Class.new(ModelBase) do
      validates_presence_of :attr1, :attr2
    end
    m = model.new
    assert !m.valid?

    m.validate_only :attr1 do
      assert !m.valid?
    end
    assert !m.valid?

    m.validate_only :attr2 do
      assert !m.valid?
    end
    assert !m.valid?

    m.validate_except :attr1, :attr2 do
      assert m.valid?
    end
    assert !m.valid?

    m.validate_only :attr3 do
      assert m.valid?
    end
    assert !m.valid?

    m.attr1 = 1
    m.validate_only :attr1 do
      assert m.valid?
    end
    assert !m.valid?

    m.validate_only :attr2 do
      assert !m.valid?
    end
    assert !m.valid?
  end

  def test_conditional_validation
    model = Class.new(ModelBase) do
      validates_presence_of :attr1, :attr2, if: :test1?
    end
    m = model.new
    assert !m.valid?

    m.validate_except :attr1, :attr2 do
      assert m.valid?
    end
    assert !m.valid?

    m.attr1 = 1
    m.validate_only :attr1 do
      assert m.valid?
    end
    assert !m.valid?

    m.validate_only :attr2 do
      assert !m.valid?
    end
    assert !m.valid?
  end

  def test_multi_conditional_validation
    model = Class.new(ModelBase) do
      validates_presence_of :attr1, :attr2, if: [:test1?, :test2?, -> { true }]
    end
    m = model.new
    assert !m.valid?

    m.validate_except :attr1, :attr2 do
      assert m.valid?
    end
    assert !m.valid?

    m.attr1 = 1
    m.validate_only :attr1 do
      assert m.valid?
    end
    assert !m.valid?

    m.validate_only :attr2 do
      assert !m.valid?
    end
    assert !m.valid?
  end

  def test_multiple_validations
    model = Class.new(ModelBase) do
      validates_presence_of :attr1, :attr2
      validates_numericality_of :attr2, :attr3
    end
    m = model.new
    assert !m.valid?

    m.attr1 = 'a'
    m.attr2 = 1
    m.validate_only :attr1, :attr2 do
      assert m.valid?
    end
    assert !m.valid?

    m.validate_only :attr2 do
      assert m.valid?
      m.attr2 = 'a'
      assert !m.valid?
    end
    assert !m.valid?

  end

  def test_returned_value
    model = Class.new(ModelBase) do
    end

    m = model.new

    test = m.validate_only :attr1 do
      'test string'
    end
    assert_equal test, 'test string'

    test = m.validate_except :attr1 do
      'test string'
    end
    assert_equal test, 'test string'

  end

  def test_validates_with
    model = Class.new(ModelBase) do
      validates_with(Class.new(ActiveModel::Validator) do
        def validate(record)
          record.errors.add :base, 'attr1 should be above zero' unless record.attr1 > 0
        end
      end)
      validates_presence_of :attr2
    end

    m = model.new
    m.attr1 = 0

    m.validate_only :attr1 do
      assert !m.valid?
    end

    m.attr1 = 1

    m.validate_only :attr1 do
      assert m.valid?
    end

  end



end