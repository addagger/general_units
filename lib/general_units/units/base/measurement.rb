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
    
      def self.i18n_scope_key
        'general_units'
      end
    
      def self.i18n_class_key
        "#{i18n_scope_key}.#{name.demodulize.underscore}"
      end
      
      def self.i18n_format_key(format = nil)
        [i18n_class_key, :formats, format].compact.join(".")
      end
      
      def self.i18n_key(*args)
        key = args.first
        options = args.extract_options!
        options[:locale] ||= :en
        begin
          I18n.t("#{i18n_format_key(options[:format])}.#{key}", options.merge(:raise => true))
        rescue
          begin
            I18n.t("#{i18n_class_key}.#{key}", options.merge(:raise => true))
          rescue
            I18n.t("#{i18n_scope_key}.#{key}", options)
          end
        end
      end
      
      def i18n_delimeter(options = {})
        self.class.i18n_key(:delimeter, options)
      end
    
      def attributes
        {:amount => amount, :unit => unit}
      end

      def to_s(*args)
        options = args.extract_options!
        value = "#{rounded(options[:round])}".gsub(".", i18n_delimeter(options))
        unit_string = unit.to_s(options.merge(:count => rounded(options[:round]), :format => :short))
        "#{value} #{unit_string}"
      end
      
      def rounded(round = nil)
        to_f.divmod(1).last == 0 ? to_f.round(0) : to_f.round(round||2)
      end
      
      def inspect
        "<#{self.class.name} amount=#{to_f} unit=#{unit.code}>"
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
        amount == valid_amount(other_object)
      rescue NoMethodError
        false
      end

      def eql?(other_object)
        self == other_object
      end

      def <=>(other_object)
        amount <=> valid_amount(other_object)
      rescue NoMethodError
        raise ArgumentError, "Comparison of #{self.class} with #{val.inspect} failed"
      end
      
      def >(other_object)
        amount > valid_amount(other_object)
      end
     
      def <(other_object)
        amount < valid_amount(other_object)
      end
      
      def >=(other_object)
        amount >= valid_amount(other_object)
      end
     
      def <=(other_object)
        amount <= valid_amount(other_object)
      end
    
      def positive?
        self > 0
      end

      def negative?
        self < 0
      end

      def +(other_object)
        self.class.new(amount + valid_amount(other_object), unit)
      end

      def -(other_object)
        self.class.new(amount - valid_amount(other_object), unit)
      end

      def *(other_object)
        self.class.new(amount * valid_amount(other_object), unit)
      end

      def /(other_object)
        self.class.new(amount / valid_amount(other_object), unit)
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
        quotient, remainder = amount.divmod(valid_amount(other_object))
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

      def valid_amount(other_object)
        case other_object
        when self.class then other_object.convert_to(unit).amount
        when Numeric then other_object
        else other_object.send(:"to_#{measurement}").convert_to(unit).amount
        end
      end

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