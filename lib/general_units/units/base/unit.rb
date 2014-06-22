module GeneralUnits
  module Base
    class Unit
      METRIC_SYSTEMS = [:metric, :english, :american]
    
      attr_reader :code, :name, :short, :fractional, :system

      def initialize(code, name, short, fractional, system = :metric)
        @code = code
        @name = name.to_s
        @short = short.to_s
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

      def to_s
        name
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