# frozen_string_literal: true

require_relative 'abstract'

module ColorCalculator
  module Clump
    class Lab < Abstract
      class << self
        def attributes
          %i[lightness alpha beta]
        end
      end
    end
  end
end
