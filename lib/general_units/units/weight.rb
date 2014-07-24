module GeneralUnits
  class Weight < ::GeneralUnits::Base::Measurement
    
    class Unit < ::GeneralUnits::Base::Unit
      alias :grams :fractional
    end
    
    self.units = [Unit.new(self, :short_ton_us, 907184.74, :american),
                  Unit.new(self, :pound_us, 453.59237, :american),
                  Unit.new(self, :ounce_us, 28.349523, :american),
                  Unit.new(self, :stone, 6350.2932, :english),
                  Unit.new(self, :long_ton_uk, 1016046.9, :english),
                  Unit.new(self, :metric_ton, 1000000.0),
                  Unit.new(self, :kilogram, 1000.0),
                  Unit.new(self, :gram, 1.0)]

    def convert_to(unit)
      if convert_unit = valid_unit?(unit)
        convert_amount = amount * @unit.grams/convert_unit.grams
        Weight.new(convert_amount, unit)
      end
    end
    
  end
end