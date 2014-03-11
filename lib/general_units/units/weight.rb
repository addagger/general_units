require 'general_units/units/arithmetics/methods'

module GeneralUnits
  class Weight
    ::GeneralUnits::Arithmetics.extend_class(self)
    
    class Unit
      attr_reader :name, :short, :grams
  
      def initialize(name, short, grams)
        @name = name.to_s
        @short = short.to_s
        @grams = grams.to_d
      end
  
      def to_s
        name
      end
  
      def inspect
        "\"#{name}\""
      end
    end

    UNITS = {:short_ton_us => Unit.new("Short ton (US)", "Sht.", 907184.74),
             :pound_us => Unit.new("Pound (US)", "Pnd.", 453.59237),
             :ounce_us => Unit.new("Ounce (US)", "Ounce", 28.349523),
             :stone => Unit.new("Stone", "Stn", 6350.2932),
             :long_ton_uk => Unit.new("Long Ton (UK)", "Lngt.", 1016046.9),
             :metric_ton => Unit.new("Metric Ton", "Ton", 1000000.0),
             :kilogram => Unit.new("Kilogram", "Kg.", 1000.0),
             :gram => Unit.new("Gram", "g.", 1.0)}

    attr_reader :amount, :unit
    delegate :to_f, :to => :amount

    def initialize(amount = 0, unit)
      if unit = valid_unit?(unit)
        @amount = amount.try(:to_d)||0.to_d
        @unit = unit
      end
    end

    def convert_to(unit)
      if convert_unit = valid_unit?(unit)
        convert_amount = amount * @unit.grams/convert_unit.grams
        Weight.new(convert_amount, unit)
      end
    end

    def to_s(round = 2)
      "#{to_f.round(round)} #{unit.short}"
    end

    def to_weight
      self
    end

    private

    def valid_unit?(unit)
      unit_object = case unit
      when String then UNITS[unit.to_sym]
      when Symbol then UNITS[unit]
      when Unit then unit
      else UNITS[unit.to_s.to_sym]
      end
      unit_object || raise(TypeError, "Unprocessable unit #{unit.inspect}")
    end

  end
end