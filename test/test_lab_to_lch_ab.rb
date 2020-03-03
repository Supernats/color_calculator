# frozen_string_literal: true

require 'helper'
require 'securerandom'

class TestLabToLchAb < Minitest::Test
  DATA = [
      [[0, 0, 0], [0, 0, 0]],
      [[53.3890, 0, 0], [53.3890, 0, 0]],
      [[100, 0, 0], [100, 0, 0]],
      [[41.5206, -4.5733, -33.4939], [41.5206, 33.8047, 262.2248]],
      [[81.0622, -60.9416, 48.7707], [81.0622, 78.0542, 141.3302]]
  ]

  DATA.each do |lab, lch_ab|
    name = ['test_as_a_class', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
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

  DATA.each do |lab, lch_ab|
    name = ['test_as_a_proc', SecureRandom.uuid.delete('-')].join('_')

    define_method(name) do
      input = ColorCalculator::Clump::Lab.new(*lab)
      expected = ColorCalculator::Clump::LchAb.new(*lch_ab)
      result = ColorCalculator::Conversion::LabToLchAb.to_proc.call(input)

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

  def test_that_it_can_be_a_proc
    assert_kind_of Proc, ColorCalculator::Conversion::LabToLchAb.to_proc
  end
end
