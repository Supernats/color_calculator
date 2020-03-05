# frozen_string_literal: true

require_relative '../shared/composable'
require_relative '../conversion/rgb_to_xyz'
require_relative '../conversion/xyz_to_lab'
require_relative '../conversion/lab_to_lch'

module ColorCalculator
  module Conversion
    class RgbToLch
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
          ColorCalculator::Conversion::LabToLch
        ]
      end
    end
  end
end
