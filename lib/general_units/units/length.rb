require 'general_units/units/base/measurement'
require 'general_units/units/base/unit'
require 'general_units/units/arithmetics/methods'

module GeneralUnits
  class Length < ::GeneralUnits::Base::Measurement
    ::GeneralUnits::Arithmetics.extend_class(self)
    
    class Unit < ::GeneralUnits::Base::Unit
      alias :millimeters :fractional
    end

    self.units = [Unit.new(:mile_nautical, "Mile (nautical)", "mln", 1852000.0, :english),
                  Unit.new(:mile, "Mile", "ml", 1609344.0, :english),
                  Unit.new(:yard, "Yard", "yrd", 914.4, :english),
                  Unit.new(:foot, "Foot", "ft", 304.8, :english),
                  Unit.new(:inch, "Inch", "in", 25.4, :english),
                  Unit.new(:kilometer, "Kilometer", "km", 1000000.0),
                  Unit.new(:meter, "Meter", "m", 1000.0),
                  Unit.new(:centimeter, "Centimeter", "cm", 10.0),
                  Unit.new(:millimeter, "Millimeter", "mm", 1.0)]

    def convert_to(unit)
      if convert_unit = valid_unit?(unit)
        convert_amount = amount * @unit.millimeters/convert_unit.millimeters
        Length.new(convert_amount, unit)
      end
    end

    def to_length
      self
    end

  end
end