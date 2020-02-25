# frozen_string_literal: true

module ColorCalculator
  module Composable
    def to_proc
      proc(&method(:call))
    end

    def call(args)
      new(args).call
    end
  end
end
