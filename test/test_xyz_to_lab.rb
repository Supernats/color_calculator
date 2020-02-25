# frozen_string_literal: true

require 'helper'

class TestXyzToLab < Minitest::Test
  def test_as_a_class
    [
      [[0, 0, 0], [0, 0, 0]],
      [[0.206383, 0.214041, 0.176629], [53.3890, 0, 0]],
      [[0.964220, 1.000000, 0.825210], [100, 0, 0]],
      [[0.111177, 0.121926, 0.240861], [41.5206, -4.5733, -33.4939]],
      [[0.352240, 0.585836, 0.171983], [81.0622, -60.9416, 48.7707]]
    ].each do |xyz, lab|
      input = ColorCalculator::Clump::Xyz.new(*xyz)
      expected = ColorCalculator::Clump::Lab.new(*lab)
      result = ColorCalculator::Conversion::XyzToLab.call(input)

      [:lightness, :alpha, :beta].each do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.001,
          <<~ERROR
            Failed with XYZ input #{xyz}
          ERROR
        )
      end
    end
  end

  def test_that_it_can_be_a_proc
    assert_kind_of Proc, ColorCalculator::Conversion::XyzToLab.to_proc
  end

  def test_as_a_proc
    [
      [[0, 0, 0], [0, 0, 0]],
      [[0.206383, 0.214041, 0.176629], [53.3890, 0, 0]],
      [[0.964220, 1.000000, 0.825210], [100, 0, 0]],
      [[0.111177, 0.121926, 0.240861], [41.5206, -4.5733, -33.4939]],
      [[0.352240, 0.585836, 0.171983], [81.0622, -60.9416, 48.7707]]
    ].each do |xyz, lab|
      input = ColorCalculator::Clump::Xyz.new(*xyz)
      expected = ColorCalculator::Clump::Lab.new(*lab)
      result = ColorCalculator::Conversion::XyzToLab.to_proc.call(input)

      [:lightness, :alpha, :beta].each do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.001,
          <<~ERROR
            Failed with XYZ input #{xyz}
          ERROR
        )
      end
    end
  end
end
