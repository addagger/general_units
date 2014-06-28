module GeneralUnits
  module Base
    class Measurement
      class_attribute :units unless defined?(units)
      
      attr_reader :amount, :unit
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
      
      def inspect
        "<#{self.class.name} amount=#{amount} unit=#{unit}>"
      end
    
      def formatted(round = nil, &block)
        if block_given?
          yield to_s(round), unit
        else
          "#{to_s(round)} #{unit.short}"          
        end
      end
      
      ### ARITHMETICS START ###
      delegate :to_f, :to_d, :to_i, :round, :to => :amount
    
      def measurement
        self.class.name.split("::").last.underscore
      end
    
      def -@
        self.class.new(-amount, unit)
      end

      def ==(other_object)
        other_object = other_object.send(:"to_#{measurement}") unless other_object.is_a?(self.class)
        amount == other_object.convert_to(unit).amount
      rescue NoMethodError
        false
      end

      def eql?(other_object)
        self == other_object
      end

      def <=>(val)
        val = val.send(:"to_#{measurement}")
        unless amount == 0 || val.amount == 0 || unit == val.unit
          val = val.convert_to(unit)
        end
        amount <=> val.amount
      rescue NoMethodError
        raise ArgumentError, "Comparison of #{self.class} with #{val.inspect} failed"
      end
      
      def >(other_object)
        other_object = other_object.is_a?(self.class) ? other_object.convert_to(unit) : other_object.send(:"to_#{measurement}")
        amount > other_object.amount
      end
     
      def <(other_object)
        other_object = other_object.is_a?(self.class) ? other_object.convert_to(unit) : other_object.send(:"to_#{measurement}")
        amount < other_object.amount
      end
      
      def >=(other_object)
        other_object = other_object.is_a?(self.class) ? other_object.convert_to(unit) : other_object.send(:"to_#{measurement}")
        amount >= other_object.amount
      end
     
      def <=(other_object)
        other_object = other_object.is_a?(self.class) ? other_object.convert_to(unit) : other_object.send(:"to_#{measurement}")
        amount <= other_object.amount
      end
    
      def positive?
        amount > 0
      end

      def negative?
        amount < 0
      end

      def +(other_object)
        other_object = other_object.is_a?(self.class) ? other_object.convert_to(unit) : other_object.send(:"to_#{measurement}")
        self.class.new(amount + other_object.amount, unit)
      end

      def -(other_object)
        other_object = other_object.is_a?(self.class) ? other_object.convert_to(unit) : other_object.send(:"to_#{measurement}")
        self.class.new(amount - other_object.amount, unit)
      end

      def *(value)
        case value
        when Numeric then self.class.new(amount * value, unit)
        when self.class then self.class.new(amount * value.convert_to(unit).amount, unit)
        else raise ArgumentError, "Can't multiply a #{self.class} by a #{value.class.name}'s value"
        end
      end

      def /(value)
        case value
        when Numeric then self.class.new(amount / value, unit)
        when self.class then self.class.new(amount / value.convert_to(unit).amount, unit)
        else raise ArgumentError, "Can't divide a #{self.class} by a #{value.class.name}'s value"
        end
      end

      def div(value)
        amount.div(value)
      end

      def divmod(val)
        if val.is_a?(self.class)
          divmod_object(val)
        else
          divmod_other(val)
        end
      end

      def divmod_object(val)
        amount = val.convert_to(unit).amount
        quotient, remainder = amount.divmod(amount)
        [quotient, self.class.new(remainder, unit)]
      end
      private :divmod_object

      def divmod_other(val)
        quotient, remainder = amount.divmod(val.send(:"to_#{measurement}", unit).amount)
        [self.class.new(quotient, unit), self.class.new(remainder, unit)]
      end
      private :divmod_other

      def modulo(val)
        divmod(val)[1]
      end

      def %(val)
        modulo(val)
      end

      def remainder(val)
        if val.is_a?(self.class) && unit != val.unit
          val = val.convert_to(unit)
        end

        if (amount < 0 && val < 0) || (amount > 0 && val > 0)
          self.modulo(val)
        else
          self.modulo(val) - (val.is_a?(self.class) ? val : self.class.new(val, unit))
        end
      end

      def abs
        self.class.new(amount.abs, unit)
      end

      def zero?
        amount == 0
      end

      def nonzero?
        amount != 0 ? self : nil
      end

      def coerce(other)
        [self, other]
      end
      ### ARITHMETICS END ###
      
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