# frozen_string_literal: true

require 'helper'

class TestRgbToLchAb < Minitest::Test
  DATA_SCALED = [
    [[0, 0, 0], [0, 0, 0]],
    [[255, 255, 255], [100, 0, 0]],
    [[60, 230, 123], [81.2545, 72.9983, 147.5489]],
  ]

  def test_as_a_class
    DATA_SCALED.each do |rgb, lch_ab|
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

  def test_that_it_can_be_a_proc
    assert_kind_of Proc, ColorCalculator::Conversion::RgbToLchAb.to_proc
  end

  def test_as_a_proc
    DATA_SCALED.each do |rgb, lch_ab|
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
end
