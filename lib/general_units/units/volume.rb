module GeneralUnits
  class Volume < ::GeneralUnits::Base::Measurement
    
    class Unit < ::GeneralUnits::Base::Unit
      alias :cubic_millimeters :fractional
    end

    self.units = Length.units.map do |unit|
                   Unit.new(self, :"cubic_#{unit.code}", unit.fractional**3, unit.system)
                 end

    def convert_to(unit)
      if convert_unit = valid_unit?(unit)
        convert_amount = amount * @unit.cubic_millimeters/convert_unit.cubic_millimeters
        Volume.new(convert_amount, unit)
      end
    end

  end
end