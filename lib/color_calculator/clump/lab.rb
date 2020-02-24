# frozen_string_literal: true

module ColorCalculator
  module Clump
    class Lab
      def initialize(lightness, alpha, beta)
        @lightness = lightness
        @alpha = alpha
        @beta = beta
      end

      attr_reader :lightness, :alpha, :beta
    end
  end
end
