# frozen_string_literal: true

module ColorCalculator
  module Clump
    class LchAb
      def initialize(lightness, chroma, hue)
        @lightness = lightness
        @chroma = chroma
        @hue = hue
      end

      attr_reader :lightness, :chroma, :hue
    end
  end
end
