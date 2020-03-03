# frozen_string_literal: true

require_relative 'abstract'

module ColorCalculator
  module Clump
    class LchAb < Abstract
      class << self
        def attributes
          %i[lightness chroma hue]
        end
      end
    end
  end
end
