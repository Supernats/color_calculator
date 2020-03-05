# frozen_string_literal: true

require 'helper'
require 'securerandom'

require_relative '../lib/color_calculator/clump/lab'
require_relative '../lib/color_calculator/clump/xyz'

require_relative '../lib/color_calculator/conversion/lab_to_xyz'

class TestLabToXyz < Minitest::Test
  DATA = [
    [[0, 0, 0], [0, 0, 0]],
    [[53.3890, 0, 0], [0.206383, 0.214041, 0.176629]],
    [[100, 0, 0], [0.964220, 1.000000, 0.825210]],
    [[41.5206, -4.5733, -33.4939], [0.111177, 0.121926, 0.240861]],
    [[81.0622, -60.9416, 48.7707], [0.352240, 0.585836, 0.171983]]
  ]

  DATA.each do |lab, xyz|
    name = ['test_as_a_class', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Lab.new(*lab)
      expected = ColorCalculator::Clump::Xyz.new(*xyz)
      result = ColorCalculator::Conversion::LabToXyz.call(input)

      %i[x y z].each do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.001,
          <<~ERROR
            Failed with lab input #{lab}
          ERROR
        )
      end
    end
  end

  DATA.each do |lab, xyz|
    name = ['test_as_a_class', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Lab.new(*lab)
      expected = ColorCalculator::Clump::Xyz.new(*xyz)
      result = ColorCalculator::Conversion::LabToXyz.to_proc.call(input)

      %i[x y z].each do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.001,
          <<~ERROR
            Failed with lab input #{lab}
          ERROR
        )
      end
    end
  end

  def test_that_it_can_be_a_proc
    assert_kind_of Proc, ColorCalculator::Conversion::XyzToLab.to_proc
  end
end
