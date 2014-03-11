require 'general_units/units/arithmetics/methods'

module GeneralUnits
  class Length
    ::GeneralUnits::Arithmetics.extend_class(self)
    
    class Unit
      attr_reader :name, :short, :millimeters
  
      def initialize(name, short, millimeters)
        @name = name.to_s
        @short = short.to_s
        @millimeters = millimeters.to_d
      end
  
      def to_s
        name
      end
  
      def inspect
        "\"#{name}\""
      end
    end

    UNITS = {:mile_nautical => Unit.new("Mile (nautical)", "mln.", 1852000.0),
             :mile => Unit.new("Mile", "ml.", 1609344.0),
             :yard => Unit.new("Yard", "yrd.", 914.4),
             :foot => Unit.new("Foot", "ft.", 304.8),
             :inch => Unit.new("Inch", "in.", 25.4),
             :kilometer => Unit.new("Kilometer", "km.", 1000000.0),
             :meter => Unit.new("Meter", "m.", 1000.0),
             :centimeter => Unit.new("Centimeter", "cm.", 10.0),
             :millimeter => Unit.new("Millimeter", "mm.", 1.0)}

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

    def to_s(round = 2)
      "#{to_f.round(round)} #{unit.short}"
    end

    def to_length
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