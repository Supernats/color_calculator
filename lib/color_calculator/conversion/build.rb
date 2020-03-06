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
      MAP = {
        lab: {
          lab: NOOP,
          lch: LabToLch.to_proc,
          rgb: [LabToXyz, XyzToRgb].map(&:to_proc).reduce(:>>),
          xyz: LabToXyz.to_proc
        },
        lch: {
          lab: LchToLab.to_proc,
          lch: NOOP,
          rgb: [LchToLab, LabToXyz, XyzToRgb].map(&:to_proc).reduce(:>>),
          xyz: [LchToLab, LabToXyz].map(&:to_proc).reduce(:>>)
        },
        rgb: {
          lab: [RgbToXyz, XyzToLab].map(&:to_proc).reduce(:>>),
          lch: [RgbToXyz, XyzToLab, LabToLch].map(&:to_proc).reduce(:>>),
          rgb: NOOP,
          xyz: RgbToXyz.to_proc
        },
        xyz: {
          lab: XyzToLab.to_proc,
          lch: [XyzToLab, LabToLch].map(&:to_proc).reduce(:>>),
          rgb: XyzToRgb.to_proc,
          xyz: NOOP
        }
      }

      class << self
        def call(from, to)
          MAP[from][to]
        end
      end
    end
  end
end
