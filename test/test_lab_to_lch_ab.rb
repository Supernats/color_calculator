# frozen_string_literal: true

require 'helper'

require 'color_calculator/clump'
require 'color_calculator/conversion'

class TestLabToLchAb < Minitest::Test
  def test_lab_to_lch_ab
    [
      [[0, 0, 0], [0, 0, 0]],
      [[53.3890, 0, 0], [53.3890, 0, 0]],
      [[100, 0, 0], [100, 0, 0]],
      [[41.5206, -4.5733, -33.4939], [41.5206, 33.8047, 262.2248]],
      [[81.0622, -60.9416, 48.7707], [81.0622, 78.0542, 141.3302]]
    ].each do |lab, lch_ab|
      input = ColorCalculator::Clump::Lab.new(*lab)
      expected = ColorCalculator::Clump::LchAb.new(*lch_ab)
      result = ColorCalculator::Conversion::LabToLchAb.call(input)

      [:lightness, :chroma, :hue].each do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.001,
          <<~ERROR
            #{message} failed with Lab input #{lab}
          ERROR
        )
      end
    end
  end
end
