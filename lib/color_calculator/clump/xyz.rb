# frozen_string_literal: true

module ColorCalculator
  module Clump
    class Xyz
      def initialize(x, y, z)
        if [x, y, z].any? { |num| !(0..1).cover?(num) }
          raise 'All xyz values must be normalized'
        end

        @x = x
        @y = y
        @z = z
      end

      attr_reader :x, :y, :z
    end
  end
end
