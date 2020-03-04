# frozen_string_literal: true

require 'helper'
require 'securerandom'

require_relative '../lib/color_calculator/clump/rgb'
require_relative '../lib/color_calculator/clump/xyz'
require_relative '../lib/color_calculator/conversion/rgb_to_xyz'

class TestRgbToXyz < Minitest::Test
  DATA_SCALED = [
    [[0, 0, 0], [0, 0, 0]],
    [[255, 255, 255], [0.964220, 1.000000, 0.825210]],
    [[127, 127, 127], [0.204637, 0.212231, 0.175135]],
    [[76, 229, 102], [0.352240, 0.585836, 0.171983]]
  ]

  DATA_NORMALIZED = [
    [[0, 0, 0], [0, 0, 0]],
    [[1, 1, 1], [0.964220, 1.000000, 0.825210]],
    [[0.5, 0.5, 0.5], [0.206383, 0.214041, 0.176629]],
    [[0.2, 0.4, 0.6], [0.111177, 0.121926, 0.240861]]
  ]

  DATA_SCALED.each do |rgb, xyz|
    name = ['test_scaled_as_a_class', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Rgb.new(*rgb, normalized: false)
      expected = ColorCalculator::Clump::Xyz.new(*xyz)
      result = ColorCalculator::Conversion::RgbToXyz.call(input)
      
      [:x, :y, :z].each  do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.0001,
          <<~ERROR
            Failed with RGB input #{rgb}
          ERROR
        )
      end
    end
  end

  DATA_NORMALIZED.each do |rgb, xyz|
    name = ['test_normalized_as_a_class', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Rgb.new(*rgb, normalized: true)
      expected = ColorCalculator::Clump::Xyz.new(*xyz)
      result = ColorCalculator::Conversion::RgbToXyz.call(input)
      
      [:x, :y, :z].each  do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.0001,
          <<~ERROR
            Failed with RGB input #{rgb}
          ERROR
        )
      end
    end
  end


  DATA_SCALED.each do |rgb, xyz|
    name = ['test_scaled_as_a_proc', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Rgb.new(*rgb, normalized: false)
      expected = ColorCalculator::Clump::Xyz.new(*xyz)
      result = ColorCalculator::Conversion::RgbToXyz.to_proc.call(input)

      [:x, :y, :z].each  do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.0001,
          <<~ERROR
            Failed with RGB input #{rgb}
          ERROR
        )
      end
    end
  end

  DATA_NORMALIZED.each do |rgb, xyz|
    name = ['test_normalized_as_a_proc', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Rgb.new(*rgb, normalized: true)
      expected = ColorCalculator::Clump::Xyz.new(*xyz)
      result = ColorCalculator::Conversion::RgbToXyz.to_proc.call(input)
      
      [:x, :y, :z].each  do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.0001,
          <<~ERROR
            Failed with RGB input #{rgb}
          ERROR
        )
      end
    end
  end

  def test_that_it_can_be_a_proc
    assert_kind_of Proc, ColorCalculator::Conversion::RgbToXyz.to_proc
  end
end
