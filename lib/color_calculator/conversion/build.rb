# frozen_string_literal: true

require_relative 'lab_to_lch'
require_relative 'lab_to_xyz'
require_relative 'lch_to_lab'
require_relative 'rgb_to_lch'
require_relative 'rgb_to_xyz'
require_relative 'xyz_to_lab'
require_relative 'xyz_to_rgb'

module ColorCalculator
  module Conversion
    class Build
      NOOP = -> (value) { value }

      # Doesn't seem like it's worth it to build a proper graph for this yet.
      # This map is fine, even if it is a bit repetitive.
      MAP = Hash[
        {
          lab: {
            lab: [NOOP],
            lch: [LabToLch],
            rgb: [LabToXyz, XyzToRgb],
            xyz: [LabToXyz]
          },
          lch: {
            lab: [LchToLab],
            lch: [NOOP],
            rgb: [LchToLab, LabToXyz, XyzToRgb],
            xyz: [LchToLab, LabToXyz]
          },
          rgb: {
            lab: [RgbToXyz, XyzToLab],
            lch: [RgbToXyz, XyzToLab, LabToLch],
            rgb: [NOOP],
            xyz: [RgbToXyz],
          },
          xyz: {
            lab: [XyzToLab],
            lch: [XyzToLab, LabToLch],
            rgb: [XyzToRgb],
            xyz: [NOOP],
          }
        }.map do |top_level_key, subhash|
          [
            top_level_key,
            Hash[
              subhash.map do |subkey, callable_array|
                [subkey, callable_array.map(&:to_proc).reduce(:>>)]
              end
            ]
          ]
        end
      ]

      class << self
        def call(from, to)
          MAP[from][to]
        end
      end
    end
  end
end
