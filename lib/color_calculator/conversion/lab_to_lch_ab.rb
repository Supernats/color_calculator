# frozen_string_literal: true

module ColorCalculator
  module Conversion
    class LabToLchAb
      class << self
        def call(args)
          new(args).call
        end
      end

      RADIANS_TO_DEGREES = 180 / Math::PI

      def initialize(lab)
        @lab = lab
      end

      def call
        ColorCalculator::Clump::LchAb.new(lightness, chroma, hue)
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
