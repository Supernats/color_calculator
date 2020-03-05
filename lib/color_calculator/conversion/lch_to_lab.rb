# frozen_string_literal: true

require_relative '../clump/lab'
require_relative '../clump/lch'
require_relative '../shared/composable'
require_relative '../shared/constants'

module ColorCalculator
  module Conversion
    class LchToLab
      extend Composable

      def initialize(lch)
        @lch = lch
      end

      def call
        Clump::Lab.new(lightness, alpha, beta)
      end

      private

      attr_reader :lch

      def lightness
        lch.lightness
      end

      def alpha
        lch.chroma * Math.cos(lch.hue * Constants::DEGREES_TO_RADIANS)
      end

      def beta
        lch.chroma * Math.sin(lch.hue * Constants::DEGREES_TO_RADIANS)
      end
    end
  end
end
