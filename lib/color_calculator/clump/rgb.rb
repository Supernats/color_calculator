# frozen_string_literal: true

require_relative 'abstract'

module ColorCalculator
  module Clump
    class Rgb < Abstract
      class << self
        def attributes
          %i[red green blue]
        end
      end

      def initialize(*attributes, normalized:)
        @red, @green, @blue = attributes
        @normalized = normalized
      end

      %i[red green blue].each do |value|
        define_method(value) do
          Rational(instance_variable_get("@#{value}"), scale)
        end
      end

      private

      attr_reader :normalized

      def scale
        normalized ? 1 : 255
      end
    end
  end
end
