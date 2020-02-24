# frozen_string_literal: true

module ColorCalculator
  module Conversion
    class XyzToLab
      class << self
        def call(args)
          new(args).call
        end
      end

      D50 = { x: 0.964220, y: 1.000000, z: 0.825210 }
      EPSILON = 0.008856
      KAPPA = 903.3

      APPLE = -> (value) do
        value ** Rational(1, 3)
      end

      BANANA = -> (value) do
        ((KAPPA * value) + 16) / 116
      end

      FRUIT = -> (value) do
        (value > EPSILON ? APPLE : BANANA).call(value)
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
          xyz.public_send(symbol) / D50.fetch(symbol)
        end
      end
    end
  end
end
