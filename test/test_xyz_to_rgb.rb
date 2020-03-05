# frozen_string_literal: true

require 'helper'
require 'securerandom'

require_relative '../lib/color_calculator/clump/rgb'
require_relative '../lib/color_calculator/clump/xyz'

require_relative '../lib/color_calculator/conversion/xyz_to_rgb'

class TestXyzToRgb < Minitest::Test
  DATA_SCALED = [
    [[0, 0, 0], [0, 0, 0]],
    [[0.964220, 1.000000, 0.825210], [255, 255, 255]],
    [[0.204637, 0.212231, 0.175135], [127, 127, 127]],
    [[0.352240, 0.585836, 0.171983], [76, 229, 102]]
  ]

  DATA_NORMALIZED = [
    [[0, 0, 0], [0, 0, 0]],
    [[0.964220, 1.000000, 0.825210], [1, 1, 1]],
    [[0.206383, 0.214041, 0.176629], [0.5, 0.5, 0.5]],
    [[0.111177, 0.121926, 0.240861], [0.2, 0.4, 0.6]]
  ]

  DATA_SCALED.each do |xyz, rgb|
    name = ['test_scaled_as_a_class', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Xyz.new(*xyz)
      expected = ColorCalculator::Clump::Rgb.new(*rgb, normalized: false)
      result = ColorCalculator::Conversion::XyzToRgb.call(input)
      
      %i[red green blue].each  do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.0001,
          <<~ERROR
            Failed with xyz input #{xyz}
          ERROR
        )
      end
    end
  end

  DATA_NORMALIZED.each do |xyz, rgb|
    name = ['test_normalized_as_a_class', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Xyz.new(*xyz)
      expected = ColorCalculator::Clump::Rgb.new(*rgb, normalized: true)
      result = ColorCalculator::Conversion::XyzToRgb.call(input)
      
      %i[red green blue].each  do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.0001,
          <<~ERROR
            Failed with xyz input #{xyz}
          ERROR
        )
      end
    end
  end


  DATA_SCALED.each do |xyz, rgb|
    name = ['test_scaled_as_a_proc', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Xyz.new(*xyz)
      expected = ColorCalculator::Clump::Rgb.new(*rgb, normalized: false)
      result = ColorCalculator::Conversion::XyzToRgb.to_proc.call(input)

      %i[red green blue].each  do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.0001,
          <<~ERROR
            Failed with xyz input #{xyz}
          ERROR
        )
      end
    end
  end

  DATA_NORMALIZED.each do |xyz, rgb|
    name = ['test_normalized_as_a_proc', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Xyz.new(*xyz)
      expected = ColorCalculator::Clump::Rgb.new(*rgb, normalized: true)
      result = ColorCalculator::Conversion::XyzToRgb.to_proc.call(input)
      
      %i[red green blue].each  do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.0001,
          <<~ERROR
            Failed with xyz input #{xyz}
          ERROR
        )
      end
    end
  end

  def test_that_it_can_be_a_proc
    assert_kind_of Proc, ColorCalculator::Conversion::XyzToRgb.to_proc
  end
end
