module GeneralUnits

  module ActiveRecordExtension
    extend ActiveSupport::Concern
  
    module ClassMethods
      
      def has_weight(*args)
        options = args.extract_options!
        prefix = args.first||:weight
        
        class_attribute :_has_weight unless defined?(_has_weight)
        self._has_weight = {prefix => {}}
        
        self._has_weight[prefix][:amount_method] = amount_method = options[:amount]||:"#{prefix}_amount"
        self._has_weight[prefix][:unit_method] = unit_method = options[:unit]||:"#{prefix}_unit"
        self._has_weight[prefix][:default_unit] = default_unit = options[:default_unit]||:kilogram
        self._has_weight[prefix][:default_unit_method] = default_unit_method = options[:default_unit_method]||:"deafult_#{prefix}_unit"
        
        class_eval <<-EOV
        
          def #{unit_method}=(value)
            if value.to_sym.in?(GeneralUnits::Weight::UNITS.keys)
              super(value.to_s) 
            else
              raise ArgumentError, "Unprocessable unit: \#{value.inspect\}"
            end
          end
        
          def #{prefix}
            begin
              if @_#{prefix}.nil? || #{amount_method}_changed? || #{unit_method}_changed?
                @_#{prefix} = GeneralUnits::Weight.new(#{amount_method}, #{unit_method})
              else
                @_#{prefix}
              end
            rescue ArgumentError, TypeError
              nil
            end
          end
          
          def #{prefix}=(value)
            case value
            when GeneralUnits::Weight
              self.#{amount_method} = value.amount
              self.#{unit_method} = value.unit
            when Array then
              self.#{amount_method} = value[0]
              self.#{unit_method} = value[1]||try(:#{default_unit_method})||:#{default_unit}
            when Hash then
              value = value.with_indifferent_access
              self.#{amount_method} = value[:amount]
              self.#{unit_method} = value[:unit]||try(:#{default_unit_method})||:#{default_unit}
            when Numeric then
              self.#{amount_method} = value
              self.#{unit_method} = try(:#{default_unit_method})||:#{default_unit}
            when nil then
              self.#{amount_method} = nil
              self.#{unit_method} = nil
            end
            #{prefix}
          end
        EOV
      end
      
      def has_length(*args)
        options = args.extract_options!
        prefix = args.first||:length
        
        class_attribute :_has_length unless defined?(_has_length)
        self._has_length = {prefix => {}}
        
        self._has_length[prefix][:amount_method] = amount_method = options[:amount]||:"#{prefix}_amount"
        self._has_length[prefix][:unit_method] = unit_method = options[:unit]||:"#{prefix}_unit"
        self._has_length[prefix][:default_unit] = default_unit = options[:default_unit]||:centimeter
        self._has_length[prefix][:default_unit_method] = default_unit_method = options[:default_unit_method]||:"deafult_#{prefix}_unit"
        
        class_eval <<-EOV
        
          def #{unit_method}=(value)
            if value.to_sym.in?(GeneralUnits::Length::UNITS.keys)
              super(value.to_s) 
            else
              raise ArgumentError, "Unprocessable unit: \#{value.inspect\}"
            end
          end
        
          def #{prefix}
            begin
              if @_#{prefix}.nil? || #{amount_method}_changed? || #{unit_method}_changed?
                @_#{prefix} = GeneralUnits::Length.new(#{amount_method}, #{unit_method})
              else
                @_#{prefix}
              end
            rescue ArgumentError, TypeError
              nil
            end
          end
          
          def #{prefix}=(value)
            case value
            when GeneralUnits::Length
              self.#{amount_method} = value.amount
              self.#{unit_method} = value.unit
            when Array then
              self.#{amount_method} = value[0]
              self.#{unit_method} = value[1]||try(:#{default_unit_method})||:#{default_unit}
            when Hash then
              value = value.with_indifferent_access
              self.#{amount_method} = value[:amount]
              self.#{unit_method} = value[:unit]||try(:#{default_unit_method})||:#{default_unit}
            when Numeric then
              self.#{amount_method} = value
              self.#{unit_method} = try(:#{default_unit_method})||:#{default_unit}
            when nil then
              self.#{amount_method} = nil
              self.#{unit_method} = nil
            end
            #{prefix}
          end
        EOV
      end
      
      def has_box(*args)
        options = args.extract_options!
        prefix = args.first||:box
        
        class_attribute :_has_box unless defined?(_has_box)
        self._has_box = {prefix => {}}
        
        self._has_box[prefix][:length_method] = length_method = options[:length]||:"#{prefix}_length"
        self._has_box[prefix][:width_method] = width_method = options[:width]||:"#{prefix}_width"
        self._has_box[prefix][:height_method] = height_method = options[:height]||:"#{prefix}_height"
        
        self._has_box[prefix][:unit_method] = unit_method = options[:unit]||:"#{prefix}_unit"
        self._has_box[prefix][:default_unit] = default_unit = options[:default_unit]||:centimeter
        self._has_box[prefix][:default_unit_method] = default_unit_method = options[:default_unit_method]||:"deafult_#{prefix}_unit"
        
        class_eval <<-EOV
        
          def #{unit_method}=(value)
            if value.to_sym.in?(GeneralUnits::Length::UNITS.keys)
              super(value.to_s) 
            else
              raise ArgumentError, "Unprocessable unit: \#{value.inspect\}"
            end
          end
          
          def #{prefix}
            begin
              if @_#{prefix}.nil? || #{length_method}_changed? || #{width_method}_changed? || #{height_method}_changed? || #{unit_method}_changed?
                @_#{prefix} = GeneralUnits::Box.new(#{length_method}, #{width_method}, #{height_method}, #{unit_method})
              else
                @_#{prefix}
              end
            rescue ArgumentError, TypeError
              nil
            end
          end
          
          def #{prefix}=(value)
            case value
            when GeneralUnits::Box then
              self.#{length_method} = value.lenght
              self.#{width_method} = value.width
              self.#{height_method} = value.height
              self.#{unit_method} = value.unit
            when Array then
              self.#{length_method} = value[0]
              self.#{width_method} = value[1]
              self.#{height_method} = value[2]
              self.#{unit_method} = value[3]||try(:#{default_unit_method})||:#{default_unit}
            when Hash then
              value = value.with_indifferent_access
              self.#{length_method} = value[:length]
              self.#{width_method} = value[:width]
              self.#{height_method} = value[:height]
              self.#{unit_method} = value[:unit]||try(:#{default_unit_method})||:#{default_unit}
            when Numeric then
              self.#{length_method} = value
              self.#{width_method} = value
              self.#{height_method} = value
              self.#{unit_method} = try(:#{default_unit_method})||:#{default_unit}
            when nil then
              self.#{length_method} = nil
              self.#{width_method} = nil
              self.#{height_method} = nil
              self.#{unit_method} = nil
            end
            #{prefix}
          end
        EOV
      end
      
    end
    
  end

end
