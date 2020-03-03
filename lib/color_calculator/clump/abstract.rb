# frozen_string_literal: true

module ColorCalculator
  module Clump
    class UnlikeComparisonError < StandardError; end

    class Abstract
      def initialize(*attributes)
        self.class.attributes.each.with_index do |name, index|
          instance_variable_set("@#{name}".to_sym, attributes[index])

          define_singleton_method(name) do
            instance_variable_get("@#{name}".to_sym)
          end
        end
      end

      def to_h
        self.class.attributes.reduce({}) do |memo, message|
          memo.merge(message => public_send(message))
        end
      end

      def ==(other)
        raise UnlikeComparisonError if self.class != other.class

        to_h == other.to_h
      end

      def inspect
        to_h.to_s
      end
      alias_method :to_s, :inspect
    end
  end
end
