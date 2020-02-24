# frozen_string_literal: true

module ColorCalculator
  module Clump
    class Rgb
      def initialize(red, green, blue, normalized:)
        @red = red
        @green = green
        @blue = blue
        @normalized = normalized
      end

      %i[red green blue].each do |value|
        define_method(value) do
          Rational(instance_variable_get("@#{value}"), scale)
        end
      end

      attr_reader :normalized

      private

      def scale
        normalized ? 1 : 255
      end
    end
  end
end
