# frozen_string_literal: true

require 'helper'
require 'securerandom'

require_relative '../lib/color_calculator/clump/lab'
require_relative '../lib/color_calculator/clump/lch'
require_relative '../lib/color_calculator/conversion/lch_to_lab'

class TestLchToLab < Minitest::Test
  DATA = [
      [[0, 0, 0], [0, 0, 0]],
      [[53.3890, 0, 0], [53.3890, 0, 0]],
      [[100, 0, 0], [100, 0, 0]],
      [[41.5206, 33.8047, 262.2248], [41.5206, -4.5733, -33.4939]],
      [[81.0622, 78.0542, 141.3302], [81.0622, -60.9416, 48.7707]]
  ]

  DATA.each do |lch, lab|
    name = ['test_as_a_class', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Lch.new(*lch)
      expected = ColorCalculator::Clump::Lab.new(*lab)
      result = ColorCalculator::Conversion::LchToLab.call(input)

      [:lightness, :alpha, :beta].each do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.001,
          <<~ERROR
            #{message} failed with Lch input #{lch}
          ERROR
        )
      end
    end
  end

  DATA.each do |lch, lab|
    name = ['test_as_a_proc', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Lch.new(*lch)
      expected = ColorCalculator::Clump::Lab.new(*lab)
      result = ColorCalculator::Conversion::LchToLab.to_proc.call(input)

      [:lightness, :alpha, :beta].each do |message|
        assert_in_delta(
          expected.public_send(message),
          result.public_send(message),
          0.001,
          <<~ERROR
            #{message} failed with Lch input #{lch}
          ERROR
        )
      end
    end
  end

  def test_that_it_can_be_a_proc
    assert_kind_of Proc, ColorCalculator::Conversion::LchToLab.to_proc
  end
end
