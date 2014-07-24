module GeneralUnits
  module Base
    class Unit
      METRIC_SYSTEMS = [:metric, :english, :american]
    
      attr_reader :owner_class, :code, :fractional, :system
      delegate :i18n_key, :to => :owner_class

      def initialize(owner_class, code, fractional, system = :metric)
        @owner_class = owner_class
        @code = code
        @fractional = fractional.to_d
        @system = system.to_sym
        METRIC_SYSTEMS.each do |s|
          class_eval do
            define_method "#{s}?" do
              self.system == s
            end
          end
        end
      end

      def to_s(*args)
        options = args.extract_options!
        options[:format] ||= :long
        options[:count] ||= 1
        i18n_key(code.to_sym, options)
      end

      def inspect
        code
      end
    
      def system
        METRIC_SYSTEMS.find {|s| s == @system}
      end
    end
  end
end