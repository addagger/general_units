module GeneralUnits
  class Weight < ::GeneralUnits::Base::Measurement
    
    class Unit < ::GeneralUnits::Base::Unit
      alias :grams :fractional
    end
    
    self.units = [Unit.new(:short_ton_us, "Short ton (US)", "Sht", 907184.74, :american),
                  Unit.new(:pound_us, "Pound (US)", "Pnd", 453.59237, :american),
                  Unit.new(:ounce_us, "Ounce (US)", "Ounce", 28.349523, :american),
                  Unit.new(:stone, "Stone", "Stn", 6350.2932, :english),
                  Unit.new(:long_ton_uk, "Long Ton (UK)", "Lngt", 1016046.9, :english),
                  Unit.new(:metric_ton, "Metric Ton", "Ton", 1000000.0),
                  Unit.new(:kilogram, "Kilogram", "Kg", 1000.0),
                  Unit.new(:gram, "Gram", "g.", 1.0)]

    def convert_to(unit)
      if convert_unit = valid_unit?(unit)
        convert_amount = amount * @unit.grams/convert_unit.grams
        Weight.new(convert_amount, unit)
      end
    end

    def to_weight
      self
    end
  end
end