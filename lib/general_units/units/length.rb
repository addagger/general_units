require 'general_units/units/arithmetics/methods'

module GeneralUnits
  class Length
    ::GeneralUnits::Arithmetics.extend_class(self)
    
    class Unit
      attr_reader :code, :name, :short, :millimeters
  
      def initialize(code, name, short, millimeters)
        @code = code
        @name = name.to_s
        @short = short.to_s
        @millimeters = millimeters.to_d
      end
  
      def to_s
        name
      end
  
      def inspect
        code
      end
    end

    UNITS = [Unit.new(:mile_nautical, "Mile (nautical)", "mln.", 1852000.0),
             Unit.new(:mile, "Mile", "ml.", 1609344.0),
             Unit.new(:yard, "Yard", "yrd.", 914.4),
             Unit.new(:foot, "Foot", "ft.", 304.8),
             Unit.new(:inch, "Inch", "in.", 25.4),
             Unit.new(:kilometer, "Kilometer", "km.", 1000000.0),
             Unit.new(:meter, "Meter", "m.", 1000.0),
             Unit.new(:centimeter, "Centimeter", "cm.", 10.0),
             Unit.new(:millimeter, "Millimeter", "mm.", 1.0)]

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
        convert_amount = amount * @unit.millimeters/convert_unit.millimeters
        Length.new(convert_amount, unit)
      end
    end

    def to_s(round = nil)
      "#{to_f.round(round||2)}"
    end
    
    def formatted(round = nil)
      "#{to_s(round)} #{unit.short}"
    end

    def to_length
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