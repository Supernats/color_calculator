# frozen_string_literal: true

require_relative '../clump/rgb'
require_relative '../clump/xyz'

require_relative '../shared/composable'
require_relative '../shared/constants'

module ColorCalculator
  module Conversion
    class XyzToRgb
      extend ColorCalculator::Composable

      XYZ_TO_RGB_TRANSFORM_D50 = [
        [3.1338561, -1.6168667, -0.4906146],
        [-0.9787684, 1.9161415, 0.0334540],
        [0.0719453, -0.2289914, 1.4052427]
      ]

      RGB_COMPAND = -> (value) do
        if value <= 0.0031308
          12.92 * value
        else
          1.055 * (value ** Rational(10, 24)) - 0.055
        end
      end 

      def initialize(xyz)
        @xyz = xyz
      end

      def call
        Clump::Rgb.new(red, green, blue, normalized: true)
      end

      private

      attr_reader :xyz

      def red
        RGB_COMPAND.call(linear_rgb.fetch(:red))
      end

      def green
        RGB_COMPAND.call(linear_rgb.fetch(:green))
      end

      def blue
        RGB_COMPAND.call(linear_rgb.fetch(:blue))
      end

      def linear_rgb
        Hash[
          %i[red green blue].zip(
            XYZ_TO_RGB_TRANSFORM_D50.map do |row|
              %i[x y z].map.with_index do |xyz_val, index|
                row[index] * xyz.public_send(xyz_val)
              end.sum
            end
          )
        ]
      end
    end
  end
end
