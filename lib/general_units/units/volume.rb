module GeneralUnits
  class Volume < ::GeneralUnits::Base::Measurement
    
    class Unit < ::GeneralUnits::Base::Unit
      alias :cubic_millimeters :fractional
    end

    self.units = Length.units.map do |unit|
                   Unit.new("cubic_#{unit.code}", "Cubic #{unit.name}", "#{unit.short}", unit.fractional**3, unit.system)
                 end

    def convert_to(unit)
      if convert_unit = valid_unit?(unit)
        convert_amount = amount * @unit.cubic_millimeters/convert_unit.cubic_millimeters
        Volume.new(convert_amount, unit)
      end
    end
    
    def to_volume
      self
    end

  end
end