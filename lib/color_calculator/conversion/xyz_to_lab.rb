# frozen_string_literal: true

require_relative '../clump/lab'
require_relative '../clump/xyz'
require_relative '../shared/composable'
require_relative '../shared/constants'

module ColorCalculator
  module Conversion
    class XyzToLab
      extend ColorCalculator::Composable

      APPLE = -> (value) do
        value ** Rational(1, 3)
      end

      BANANA = -> (value) do
        ((Constants::KAPPA * value) + 16) / 116
      end

      FRUIT = -> (value) do
        (value > Constants::EPSILON ? APPLE : BANANA).call(value)
      end

      def initialize(xyz)
        @xyz = xyz
      end

      def call
        ColorCalculator::Clump::Lab.new(lightness, alpha, beta)
      end

      private

      attr_reader :xyz

      def lightness
        (116 * FRUIT.call(y_scaled)) - 16
      end

      def alpha
        500 * (FRUIT.call(x_scaled) - FRUIT.call(y_scaled))
      end

      def beta
        200 * (FRUIT.call(y_scaled) - FRUIT.call(z_scaled))
      end

      %i[x y z].each do |symbol|
        define_method("#{symbol}_scaled") do
          xyz.public_send(symbol) / Constants::D50.fetch(symbol)
        end
      end
    end
  end
end
