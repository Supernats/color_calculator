# frozen_string_literal: true

require 'helper'
require 'securerandom'

require_relative '../lib/color_calculator/clump/rgb'
require_relative '../lib/color_calculator/clump/lch_ab'
require_relative '../lib/color_calculator/conversion/rgb_to_lch_ab'

class TestRgbToLchAb < Minitest::Test
  DATA_SCALED = [
    [[0, 0, 0], [0, 0, 0]],
    [[255, 255, 255], [100, 0, 0]],
    [[60, 230, 123], [81.2545, 72.9983, 147.5489]],
  ]

  DATA_SCALED.each do |rgb, lch_ab|
    name = ['test_as_a_class', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Rgb.new(*rgb, normalized: false)
      expected = ColorCalculator::Clump::LchAb.new(*lch_ab)
      result = ColorCalculator::Conversion::RgbToLchAb.call(input)

      [:lightness, :chroma, :hue].each do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.001,
          <<~ERROR
            #{message} failed with rgb input #{rgb}
          ERROR
        )
      end
    end
  end

  DATA_SCALED.each do |rgb, lch_ab|
    name = ['test_as_a_proc', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Rgb.new(*rgb, normalized: false)
      expected = ColorCalculator::Clump::LchAb.new(*lch_ab)
      result = ColorCalculator::Conversion::RgbToLchAb.to_proc.call(input)

      [:lightness, :chroma, :hue].each do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.001,
          <<~ERROR
            #{message} failed with rgb input #{rgb}
          ERROR
        )
      end
    end
  end

   def test_that_it_can_be_a_proc
     assert_kind_of Proc, ColorCalculator::Conversion::RgbToLchAb.to_proc
   end
end
