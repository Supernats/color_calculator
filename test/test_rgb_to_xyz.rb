# frozen_string_literal: true

require 'helper'

require 'color_calculator/clump'
require 'color_calculator/conversion'

class TestRgbToXyz < Minitest::Test
  def test_scaled
    [
      [[0, 0, 0], [0, 0, 0]],
      [[255, 255, 255], [0.964220, 1.000000, 0.825210]],
      [[127, 127, 127], [0.204637, 0.212231, 0.175135]]
    ].each do |rgb, xyz|
      input = ColorCalculator::Clump::Rgb.new(*rgb, normalized: false)
      expected = ColorCalculator::Clump::Xyz.new(*xyz)
      result = ColorCalculator::Conversion::RgbToXyz.call(input)
      
      [:x, :y, :z].each  do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.0001,
          <<~ERROR
            Failed with sRGB input #{rgb}
          ERROR
        )
      end
    end
  end

  def test_normalized
    [
      [[0, 0, 0], [0, 0, 0]],
      [[1, 1, 1], [0.964220, 1.000000, 0.825210]],
      [[0.5, 0.5, 0.5], [0.206383, 0.214041, 0.176629]]
    ].each do |rgb, xyz|
      input = ColorCalculator::Clump::Rgb.new(*rgb, normalized: true)
      expected = ColorCalculator::Clump::Xyz.new(*xyz)
      result = ColorCalculator::Conversion::RgbToXyz.call(input)
      
      [:x, :y, :z].each  do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.0001,
          <<~ERROR
            Failed with sRGB input #{rgb}
          ERROR
        )
      end
    end
  end
end
