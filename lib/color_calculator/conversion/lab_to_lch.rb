# frozen_string_literal: true

require_relative '../clump/lab'
require_relative '../clump/lch'
require_relative '../shared/composable'

module ColorCalculator
  module Conversion
    class LabToLch
      extend ColorCalculator::Composable

      RADIANS_TO_DEGREES = 180 / Math::PI

      def initialize(lab)
        @lab = lab
      end

      def call
        ColorCalculator::Clump::Lch.new(lightness, chroma, hue)
      end

      private

      attr_reader :lab

      def lightness
        lab.lightness
      end

      def chroma
        (lab.alpha ** 2 + lab.beta ** 2) ** Rational(1, 2)
      end

      def hue
        val = Math.atan2(lab.beta, lab.alpha) * RADIANS_TO_DEGREES

        return val if val >= 0

        val + 360
      end
    end
  end
end
