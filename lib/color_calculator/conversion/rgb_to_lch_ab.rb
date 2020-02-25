# frozen_string_literal: true

require 'color_calculator/shared/composable'

module ColorCalculator
  module Conversion
    class RgbToLchAb
      extend ColorCalculator::Composable

      def initialize(rgb)
        @rgb = rgb
      end

      def call
        composed_path.call(rgb)
      end

      private

      attr_reader :rgb

      def composed_path
        conversion_path.map(&:to_proc).reduce(:>>)
      end

      def conversion_path
        [
          ColorCalculator::Conversion::RgbToXyz,
          ColorCalculator::Conversion::XyzToLab,
          ColorCalculator::Conversion::LabToLchAb
        ]
      end
    end
  end
end
