# frozen_string_literal: true

require 'color_calculator/clump/rgb'
require 'color_calculator/clump/xyz'

module ColorCalculator
  module Conversion
    class RgbToXyz
      class << self
        def call(*args)
          new(*args).call
        end
      end

      def initialize(rgb)
        @rgb = rgb
      end

      def call
        ColorCalculator::Clump::Xyz.new(x, y, z)
      end

      APPLE = -> (value) do
        value / 12.92
      end

      BANANA = -> (value) do
        ((value + 0.055)/1.055) ** Rational(12, 5)
      end

      FRUIT = -> (value) do
        (value <= 0.04045 ? APPLE : BANANA).call(value)
      end

      RGB_TO_XYZ_TRANSFORM_D50 = [
       [0.4360747, 0.3850649, 0.1430804],
       [0.2225045, 0.7168786, 0.0606169],
       [0.0139322, 0.0971045, 0.7141733],
      ]

      private

      attr_reader :rgb

      def transformed_3_by_1
        RGB_TO_XYZ_TRANSFORM_D50.map do |row|
          [0, 1, 2].map do |index|
            row[index] * [red, green, blue][index]
          end.inject(:+)
        end
      end

      %i[red green blue].each do |message|
        define_method(message) do
          FRUIT.call(rgb.public_send(message))
        end
      end

      [[:x, :red], [:y, :green], [:z, :blue]].each.with_index do |tuple, index|
        define_method(tuple[0]) do
          transformed_3_by_1[index]
        end
      end
    end
  end
end
