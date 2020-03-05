# frozen_string_literal: true

module ColorCalculator
  module Constants
    RADIANS_TO_DEGREES = Rational(180, Math::PI)

    DEGREES_TO_RADIANS = Rational(Math::PI, 180)

    D50 = { x: 0.964220, y: 1.000000, z: 0.825210 }

    EPSILON = 0.008856

    KAPPA = 903.3
  end
end
