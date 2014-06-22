module GeneralUnits

  module ActiveRecordExtension
    extend ::ActiveSupport::Concern
  
    module ClassMethods
      
      def has_weight(*args)
        options = args.extract_options!
        prefix = args.first||:weight
        
        class_attribute :_has_weight unless defined?(_has_weight)
        self._has_weight = {prefix => {}}
        
        self._has_weight[prefix][:amount_field] = amount_field = options[:amount]||:"#{prefix}_amount"
        self._has_weight[prefix][:unit_field] = unit_field = options[:unit]||:"#{prefix}_unit"
        self._has_weight[prefix][:default_unit] = default_unit = options[:default_unit]||:kilogram
        self._has_weight[prefix][:default_unit_method] = default_unit_method = options[:default_unit_method]||:"deafult_#{prefix}_unit"
        
        validates_inclusion_of unit_field, :in => Weight.units.map {|u| u.code.to_s}, :if => Proc.new {|o| o.send(amount_field).present?}
        
        class_eval <<-EOV
        
          def #{unit_field}=(value)
            if value.to_sym.in?(GeneralUnits::Weight.units.map(&:code))
              super(value.to_s) 
            else
              raise ArgumentError, "Unprocessable unit: \#{value.inspect\}"
            end
          end
        
          def #{prefix}
            begin
              if @_#{prefix}.nil? || #{amount_field}_changed? || #{unit_field}_changed?
                @_#{prefix} = GeneralUnits::Weight.new(#{amount_field}, #{unit_field})
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
              self.#{amount_field} = value.amount
              self.#{unit_field} = value.unit.code
            when Array then
              self.#{amount_field} = value[0]
              self.#{unit_field} = value[1]||try(:#{default_unit_method})||:#{default_unit}
            when Hash then
              value = value.with_indifferent_access
              self.#{amount_field} = value[:amount]
              self.#{unit_field} = value[:unit]||try(:#{default_unit_method})||:#{default_unit}
            when Numeric then
              self.#{amount_field} = value
              self.#{unit_field} = try(:#{default_unit_method})||:#{default_unit}
            when nil then
              self.#{amount_field} = nil
              self.#{unit_field} = nil
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
        
        self._has_length[prefix][:amount_field] = amount_field = options[:amount]||:"#{prefix}_amount"
        self._has_length[prefix][:unit_field] = unit_field = options[:unit]||:"#{prefix}_unit"
        self._has_length[prefix][:default_unit] = default_unit = options[:default_unit]||:centimeter
        self._has_length[prefix][:default_unit_method] = default_unit_method = options[:default_unit_method]||:"deafult_#{prefix}_unit"
        
        validates_inclusion_of unit_field, :in => Length.units.map {|u| u.code.to_s}, :if => Proc.new {|o| o.send(amount_field).present?}
        
        class_eval <<-EOV
        
          def #{unit_field}=(value)
            if value.to_sym.in?(GeneralUnits::Length.units.map(&:code))
              super(value.to_s) 
            else
              raise ArgumentError, "Unprocessable unit: \#{value.inspect\}"
            end
          end
        
          def #{prefix}
            begin
              if @_#{prefix}.nil? || #{amount_field}_changed? || #{unit_field}_changed?
                @_#{prefix} = GeneralUnits::Length.new(#{amount_field}, #{unit_field})
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
              self.#{amount_field} = value.amount
              self.#{unit_field} = value.unit.code
            when Array then
              self.#{amount_field} = value[0]
              self.#{unit_field} = value[1]||try(:#{default_unit_method})||:#{default_unit}
            when Hash then
              value = value.with_indifferent_access
              self.#{amount_field} = value[:amount]
              self.#{unit_field} = value[:unit]||try(:#{default_unit_method})||:#{default_unit}
            when Numeric then
              self.#{amount_field} = value
              self.#{unit_field} = try(:#{default_unit_method})||:#{default_unit}
            when nil then
              self.#{amount_field} = nil
              self.#{unit_field} = nil
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
        
        self._has_box[prefix][:length_field] = length_field = options[:length]||:"#{prefix}_length"
        self._has_box[prefix][:width_field] = width_field = options[:width]||:"#{prefix}_width"
        self._has_box[prefix][:height_field] = height_field = options[:height]||:"#{prefix}_height"
        
        self._has_box[prefix][:unit_field] = unit_field = options[:unit]||:"#{prefix}_unit"
        self._has_box[prefix][:default_unit] = default_unit = options[:default_unit]||:centimeter
        self._has_box[prefix][:default_unit_method] = default_unit_method = options[:default_unit_method]||:"deafult_#{prefix}_unit"
        
        validates_inclusion_of unit_field, :in => Length.units.map {|u| u.code.to_s}, :if => Proc.new {|o| o.send(length_field).present? || o.send(width_field).present? || o.send(height_field).present?}
        
        class_eval <<-EOV
        
          def #{unit_field}=(value)
            if value.to_sym.in?(GeneralUnits::Length.units.map(&:code))
              super(value.to_s) 
            else
              raise ArgumentError, "Unprocessable unit: \#{value.inspect\}"
            end
          end
          
          def #{prefix}
            begin
              if @_#{prefix}.nil? || #{length_field}_changed? || #{width_field}_changed? || #{height_field}_changed? || #{unit_field}_changed?
                @_#{prefix} = GeneralUnits::Box.new(#{length_field}, #{width_field}, #{height_field}, #{unit_field})
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
              self.#{length_field} = value.length
              self.#{width_field} = value.width
              self.#{height_field} = value.height
              self.#{unit_field} = value.unit.code
            when Array then
              self.#{length_field} = value[0]
              self.#{width_field} = value[1]
              self.#{height_field} = value[2]
              self.#{unit_field} = value[3]||try(:#{default_unit_method})||:#{default_unit}
            when Hash then
              value = value.with_indifferent_access
              self.#{length_field} = value[:length]
              self.#{width_field} = value[:width]
              self.#{height_field} = value[:height]
              self.#{unit_field} = value[:unit]||try(:#{default_unit_method})||:#{default_unit}
            when Numeric then
              self.#{length_field} = value
              self.#{width_field} = value
              self.#{height_field} = value
              self.#{unit_field} = try(:#{default_unit_method})||:#{default_unit}
            when nil then
              self.#{length_field} = nil
              self.#{width_field} = nil
              self.#{height_field} = nil
              self.#{unit_field} = nil
            end
            #{prefix}
          end
        EOV
      end
      
    end
    
  end

end
