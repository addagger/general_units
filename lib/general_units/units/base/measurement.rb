module GeneralUnits
  module Base
    class Measurement
      class_attribute :units unless defined?(units)
      
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

      def to_s(round = nil)
        "#{to_f.divmod(1).last == 0 ? to_f.round(0) : to_f.round(round||2)}"
      end
    
      def formatted(round = nil, &block)
        if block_given?
          yield to_s(round), unit
        else
          "#{to_s(round)} #{unit.short}"          
        end
      end
      
      private

      def valid_unit?(unit)
        unit_object = case unit
        when String, Symbol then units.find {|u| u.code.to_s == unit.to_s}
        when Unit then unit
        end
        unit_object || raise(TypeError, "Unprocessable unit #{unit.inspect}")
      end
      
    end
  end
end