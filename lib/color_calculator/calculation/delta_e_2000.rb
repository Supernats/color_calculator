# frozen_string_literal: true

require_relative '../clump/lab'

module ColorCalculator
  module Calculation
    class DeltaE2000
      class << self
        def call(*args)
          new(*args).call
        end
      end

      RADIANS_TO_DEGREES = 180.to_f / Math::PI
      DEGREES_TO_RADIANS = 1.to_f / RADIANS_TO_DEGREES

      K_OF_L = 1
      K_OF_C = 1
      K_OF_H = 1

      def initialize(sample, reference)
        @sample = sample
        @reference = reference
      end

      def call
        Math.sqrt(
          [
            Rational(delta_l_prime, K_OF_L * s_of_l) ** 2,
            Rational(delta_c_prime, K_OF_C * s_of_c) ** 2,
            Rational(delta_h_prime, K_OF_H * s_of_h) ** 2,
            [
              r_of_t,
              Rational(delta_c_prime, K_OF_C * s_of_c),
              Rational(delta_h_prime, K_OF_H * s_of_h),
            ].reduce(:*)
          ].reduce(:+)
        )
      end

      private

      attr_reader :sample, :reference

      def delta_l_prime
        sample.lightness - reference.lightness
      end

      def s_of_l
        1 + Rational(
          0.015 * ((l_bar_prime - 50) ** 2),
          Math.sqrt(20 + ((l_bar_prime - 50) ** 2))
        )
      end

      def delta_c_prime
        c_prime_sample - c_prime_reference
      end

      def s_of_c
        1 + 0.045 * c_bar_prime
      end

      def delta_h_prime
        [
          2,
          Math.sqrt(c_prime_reference * c_prime_sample),
          Math.sin(Rational(delta_little_h_prime, 2) * DEGREES_TO_RADIANS),
        ].reduce(:*)
      end

      def s_of_h
        1 + 0.015 * c_bar_prime * big_t
      end

      def r_of_t
        -1 * Math.sin(2 * delta_theta * DEGREES_TO_RADIANS) * r_of_c
      end

      %i[reference sample].each do |lab|
        define_method("c_#{lab}") do
          %i[alpha beta].
            map { |val| send(lab).public_send(val) ** 2 }.
            reduce(:+) ** Rational(1, 2)
        end
      end

      def c_bar
        (c_reference + c_sample) / 2.0
      end

      def big_g
        0.5 * (1 - Math.sqrt(Rational(c_bar ** 7, c_bar ** 7 + 25 ** 7)))
      end

      %i[reference sample].each do |lab|
        # def a_prime_reference
        # def a_prime_sample
        define_method("a_prime_#{lab}") do
          (1 + big_g) * send(lab).alpha
        end
      end

      %i[reference sample].each do |lab|
        # def c_prime_reference
        # def c_prime_sample
        define_method("c_prime_#{lab}") do
          Math.sqrt(send("a_prime_#{lab}") ** 2 + send(lab).beta ** 2)
        end
      end

      %i[reference sample].each do |lab|
        # def little_h_prime_reference
        # def little_h_prime_sample
        define_method("little_h_prime_#{lab}") do
          return 0 if [send(lab).beta, send("a_prime_#{lab}")].all? { |el| el == 0 }

          (Math.atan2(send(lab).beta, send("a_prime_#{lab}")) * RADIANS_TO_DEGREES) % 360
        end
      end

      def delta_little_h_prime
        c_prime_product = c_prime_reference * c_prime_sample
        difference = little_h_prime_sample - little_h_prime_reference

        if c_prime_product.zero?
          0
        elsif !c_prime_product.zero? && difference.abs <= 180
          difference
        elsif !c_prime_product.zero? && difference > 180
          difference - 360
        elsif !c_prime_product.zero? && difference < -180
          difference + 360
        else
          raise "SOMETHING IS WRONG"
        end
        # return 0 if c_prime_sample * c_prime_reference == 0

        # val = little_h_prime_sample - little_h_prime_reference

        # return val if val.abs >= 180
        # sign = val <=> 0

        # val - sign * 360
      end

      def l_bar_prime
        Rational(reference.lightness + sample.lightness, 2)
      end
      
      def c_bar_prime
        Rational(c_prime_reference + c_prime_sample, 2)
      end

      def little_h_bar_prime
        sum = little_h_prime_reference + little_h_prime_sample
        difference = little_h_prime_reference - little_h_prime_sample
        c_prime_product = c_prime_reference * c_prime_sample


        if difference.abs <= 180 && !c_prime_product.zero?
          Rational(sum, 2)
        elsif difference.abs > 180 && sum < 360 && !c_prime_product.zero?
          Rational(sum + 360, 2)
        elsif difference.abs > 180 && sum >= 360 && !c_prime_product.zero?
          Rational(sum - 360, 2)
        elsif c_prime_product.zero?
          sum
        else
          raise "SOMETHING IS WRONG"
        end
      end

      def big_t
        [
          1,
          -0.17 * Math.cos((little_h_bar_prime - 30) * DEGREES_TO_RADIANS),
          0.24 * Math.cos(2 * little_h_bar_prime * DEGREES_TO_RADIANS),
          0.32 * Math.cos((3 * little_h_bar_prime + 6) * DEGREES_TO_RADIANS),
          -0.2 * Math.cos((4 * little_h_bar_prime - 63) * DEGREES_TO_RADIANS),
        ].reduce(:+)
      end

      def delta_theta
        30 * Math::E ** (-1 * (Rational(little_h_bar_prime - 275, 25) ** 2))
      end

      def r_of_c
        2 * Math.sqrt(Rational(c_bar_prime ** 7, c_bar_prime ** 7 + 25 ** 7))
      end
    end
  end
end
