# frozen_string_literal: true

# This is just an example of how to use a compound conversion.
require 'helper'
require 'securerandom'

require_relative '../lib/color_calculator/clump/rgb'
require_relative '../lib/color_calculator/clump/lch'
require_relative '../lib/color_calculator/conversion'

class TestRgbToLch < Minitest::Test
  DATA_SCALED = [
    [[0, 0, 0], [0, 0, 0]],
    [[255, 255, 255], [100, 0, 0]],
    [[60, 230, 123], [81.2545, 72.9983, 147.5489]],
  ]

  DATA_SCALED.each do |rgb, lch|
    name = ['test_as_a_class', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Rgb.new(*rgb, normalized: false)
      expected = ColorCalculator::Clump::Lch.new(*lch)
      result = ColorCalculator::Conversion::Build.call(:rgb, :lch).call(input)

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
end
