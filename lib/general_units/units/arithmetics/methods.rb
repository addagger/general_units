module GeneralUnits
  
  module Arithmetics
    def self.extend_class(klass)
      unit_name = klass.name.split("::").last.underscore
      klass.class_eval <<-EOV
        delegate :to_f, :to_d, :to_i, :to => :amount
      
        def -@
          #{klass.name}.new(-amount, unit)
        end

        def ==(other_object)
          other_object = other_object.to_#{unit_name} unless other_object.is_a?(#{klass.name})
          amount == other_object.convert_to(unit).amount
        rescue NoMethodError
          false
        end

        def eql?(other_object)
          self == other_object
        end

        def <=>(val)
          val = val.to_#{unit_name}
          unless amount == 0 || val.amount == 0 || unit == val.unit
            val = val.convert_to(unit)
          end
          amount <=> val.amount
        rescue NoMethodError
          raise ArgumentError, "Comparison of #{self.class} with \#{val.inspect} failed"
        end
        
        def >(other_object)
          other_object = other_object.is_a?(#{klass.name}) ? other_object.convert_to(unit) : other_object.to_#{unit_name}
          amount > other_object.amount
        end
       
        def <(other_object)
          other_object = other_object.is_a?(#{klass.name}) ? other_object.convert_to(unit) : other_object.to_#{unit_name}
          amount < other_object.amount
        end
        
        def >=(other_object)
          other_object = other_object.is_a?(#{klass.name}) ? other_object.convert_to(unit) : other_object.to_#{unit_name}
          amount >= other_object.amount
        end
       
        def <=(other_object)
          other_object = other_object.is_a?(#{klass.name}) ? other_object.convert_to(unit) : other_object.to_#{unit_name}
          amount <= other_object.amount
        end
      
        def positive?
          amount > 0
        end

        def negative?
          amount < 0
        end

        def +(other_object)
          other_object = other_object.is_a?(#{klass.name}) ? other_object.convert_to(unit) : other_object.to_#{unit_name}
          #{klass.name}.new(amount + other_object.amount, unit)
        end

        def -(other_object)
          other_object = other_object.is_a?(#{klass.name}) ? other_object.convert_to(unit) : other_object.to_#{unit_name}
          #{klass.name}.new(amount - other_object.amount, unit)
        end

        def *(value)
          case value
          when Numeric then #{klass.name}.new(amount * value, unit)
          when #{klass.name} then #{klass.name}.new(amount * value.convert_to(unit).amount, unit)
          else raise ArgumentError, "Can't multiply a #{klass.name} by a \#{value.class.name}'s value"
          end
        end

        def /(value)
          case value
          when Numeric then #{klass.name}.new(amount / value, unit)
          when #{klass.name} then #{klass.name}.new(amount / value.convert_to(unit).amount, unit)
          else raise ArgumentError, "Can't divide a #{klass.name} by a \#{value.class.name}'s value"
          end
        end

        def div(value)
          amount.div(value)
        end

        def divmod(val)
          if val.is_a?(#{klass.name})
            divmod_object(val)
          else
            divmod_other(val)
          end
        end

        def divmod_object(val)
          amount = val.convert_to(unit).amount
          quotient, remainder = amount.divmod(amount)
          [quotient, #{klass.name}.new(remainder, unit)]
        end
        private :divmod_object

        def divmod_other(val)
          quotient, remainder = amount.divmod(val.to_#{unit_name}(unit).amount)
          [#{klass.name}.new(quotient, unit), #{klass.name}.new(remainder, unit)]
        end
        private :divmod_other

        def modulo(val)
          divmod(val)[1]
        end

        def %(val)
          modulo(val)
        end

        def remainder(val)
          if val.is_a?(#{klass.name}) && unit != val.unit
            val = val.convert_to(unit)
          end

          if (amount < 0 && val < 0) || (amount > 0 && val > 0)
            self.modulo(val)
          else
            self.modulo(val) - (val.is_a?(#{klass.name}) ? val : #{klass.name}.new(val, unit))
          end
        end

        def abs
          #{klass.name}.new(amount.abs, unit)
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
      EOV
    end
  end
  
end