# frozen_string_literal: true

require 'color_calculator/clump/rgb'
require 'color_calculator/clump/xyz'
require 'color_calculator/shared/composable'

module ColorCalculator
  module Conversion
    class RgbToXyz
      extend ColorCalculator::Composable

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

      def transformed_rgb
        Hash[
          [:red, :green, :blue].zip(
            RGB_TO_XYZ_TRANSFORM_D50.map do |row|
              %i[red green blue].map.with_index do |rgb, index|
                row[index] * energetically_linear_rgb[rgb]
              end.inject(:+)
            end
          )
        ]
      end

      def energetically_linear_rgb
        Hash[
          %i[red green blue].map do |color|
            [color, FRUIT.call(rgb.public_send(color))]
          end
        ]
      end

      (%i[x y z].zip(%i[red green blue])).each do |xyz, rgb|
        define_method(xyz) do
          transformed_rgb[rgb]
        end
      end
    end
  end
end
