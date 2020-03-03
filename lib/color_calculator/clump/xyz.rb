# frozen_string_literal: true

require_relative 'abstract'

module ColorCalculator
  module Clump
    class Xyz < Abstract
      class << self
        def attributes
          %i[x y z]
        end
      end
    end
  end
end
