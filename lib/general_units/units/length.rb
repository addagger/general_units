module GeneralUnits
  class Length < ::GeneralUnits::Base::Measurement
    
    class Unit < ::GeneralUnits::Base::Unit
      alias :millimeters :fractional
    end

    self.units = [Unit.new(self, :mile_nautical, 1852000.0, :english),
                  Unit.new(self, :mile, 1609344.0, :english),
                  Unit.new(self, :yard, 914.4, :english),
                  Unit.new(self, :foot, 304.8, :english),
                  Unit.new(self, :inch, 25.4, :english),
                  Unit.new(self, :kilometer, 1000000.0),
                  Unit.new(self, :meter, 1000.0),
                  Unit.new(self, :centimeter, 10.0),
                  Unit.new(self, :millimeter, 1.0)]

    def convert_to(unit)
      if convert_unit = valid_unit?(unit)
        convert_amount = amount * @unit.millimeters/convert_unit.millimeters
        Length.new(convert_amount, unit)
      end
    end
    
    def to_volume(unit_code)
      volume = GeneralUnits::Volume.new(amount, :"cubic_#{unit.code}")
      unit_code ? volume.convert_to(unit_code) : volume
    end

  end
end