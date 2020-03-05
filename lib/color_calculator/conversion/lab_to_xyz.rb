# frozen_string_literal: true

require_relative '../clump/lab'
require_relative '../clump/xyz'
require_relative '../shared/composable'

module ColorCalculator
  module Conversion
    class LabToXyz
      extend ColorCalculator::Composable

      def initialize(lab)
        @lab = lab
      end

      def call
        Clump::Xyz.new(x, y, z)
      end

      private

      attr_reader :lab

      def x
        x_of_r * Constants::D50.fetch(:x)
      end

      def y
        y_of_r * Constants::D50.fetch(:y)
      end

      def z
        z_of_r * Constants::D50.fetch(:z)
      end

      def f_of_x
        Rational(lab.alpha, 500) + f_of_y
      end

      def f_of_y
        Rational(lab.lightness + 16, 116)
      end

      def f_of_z
        f_of_y - Rational(lab.beta, 200)
      end

      def x_of_r
        val = f_of_x ** 3
        return val if val > Constants::EPSILON

        Rational(116 * f_of_x - 16, Constants::KAPPA)
      end

      def y_of_r
        if lab.lightness > (Constants::KAPPA * Constants::EPSILON)
          return Rational(Rational(lab.lightness + 16, 116)) ** 3
        end

        Rational(lab.lightness, Constants::KAPPA)
      end

      def z_of_r
        val = f_of_z ** 3
        return val if val > Constants::EPSILON

        Rational(116 * f_of_z - 16, Constants::KAPPA)
      end
    end
  end
end
