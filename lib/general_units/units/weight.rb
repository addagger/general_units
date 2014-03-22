require 'general_units/units/arithmetics/methods'

module GeneralUnits
  class Weight
    ::GeneralUnits::Arithmetics.extend_class(self)
    
    class Unit
      attr_reader :code, :name, :short, :grams
  
      def initialize(code, name, short, grams)
        @code = code
        @name = name.to_s
        @short = short.to_s
        @grams = grams.to_d
      end
  
      def to_s
        name
      end
  
      def inspect
        code
      end
    end

    UNITS = [Unit.new(:short_ton_us, "Short ton (US)", "Sht.", 907184.74),
             Unit.new(:pound_us, "Pound (US)", "Pnd.", 453.59237),
             Unit.new(:ounce_us, "Ounce (US)", "Ounce", 28.349523),
             Unit.new(:stone, "Stone", "Stn", 6350.2932),
             Unit.new(:long_ton_uk, "Long Ton (UK)", "Lngt.", 1016046.9),
             Unit.new(:metric_ton, "Metric Ton", "Ton", 1000000.0),
             Unit.new(:kilogram, "Kilogram", "Kg.", 1000.0),
             Unit.new(:gram, "Gram", "g.", 1.0)]

    attr_reader :amount, :unit
    delegate :to_f, :to => :amount
    delegate :hash, :to => :attributes

    def initialize(amount = 0, unit)
      if unit = valid_unit?(unit)
        @amount = amount.try(:to_d)||0.to_d
        @unit = unit
      end
    end
    
    def attributes
      {:amount => amount, :unit => unit}
    end

    def convert_to(unit)
      if convert_unit = valid_unit?(unit)
        convert_amount = amount * @unit.grams/convert_unit.grams
        Weight.new(convert_amount, unit)
      end
    end

    def to_s(round = nil)
      "#{to_f.round(round||2)}"
    end
    
    def formatted(round = nil)
      "#{to_s(round)} #{unit.short}"
    end

    def to_weight
      self
    end

    private

    def valid_unit?(unit)
      unit_object = case unit
      when String, Symbol then UNITS.find {|u| u.code.to_s == unit.to_s}
      when Unit then unit
      end
      unit_object || raise(TypeError, "Unprocessable unit #{unit.inspect}")
    end

  end
end