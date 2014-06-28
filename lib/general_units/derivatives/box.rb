require 'prime'
require 'general_units/derivatives/box/packer'

module GeneralUnits
  
  class Box
  
    VALUES = %w{length width height}
  
    attr_reader *VALUES, :unit
  
    delegate :to_f, :to => :volume
    delegate :hash, :to => :attributes
  
    def initialize(length = 0, width = 0, height = 0, unit = nil)
      VALUES.each {|v| instance_variable_set(:"@#{v}", validate_dimension_value(eval(v), unit))}
      @unit = unit||@height.unit.code
    end
  
    def attributes
      {:length => length, :width => width, :height => height, :unit => unit}
    end
  
    def values
      VALUES.map {|v| self.send(v)}
    end
    
    def amount
      volume.amount
    end
  
    def volume
      Volume.new(length * width * height, :"cubic_#{unit}")
    end
    
    def has_space?
      le  > 0 && width > 0 && height > 0
    end
  
    def convert_to(unit)
      Box.new(*values.map {|v| v.convert_to(unit).amount}, unit)
    end

    def to_s(round = nil)
      values.map {|d| d.to_s(round)}.join("x")
    end
    
    def formatted(round = nil, &block)
      if block_given?
        yield to_s(round), unit
      else
        "#{to_s(round)} #{unit.short}"          
      end
    end
    
    def two_max_values
      sorted = values.sort.reverse
      sorted.first(2)
    end
    
    def max_face
      two_max_values[0] * two_max_values[1]
    end
    
    def inspect
      "<#{self.class.name} length=#{length} width=#{width} height=#{height} unit=#{unit}>"
    end
  
    def same_size?(other_object)
      other_object = validate_box(other_object)
      eval VALUES.permutation.to_a.map {|values_names| "(length == other_object.#{values_names[0]} && width == other_object.#{values_names[1]} && height == other_object.#{values_names[2]})"}.join("||")
    end
  
    def includes?(other_object)
      other_object = validate_box(other_object)
      eval VALUES.permutation.to_a.map {|values_names| "(length >= other_object.#{values_names[0]} && width >= other_object.#{values_names[1]} && height >= other_object.#{values_names[2]})"}.join("||")
    end
  
    ### ARITHMETICS START ###
    delegate :<=>, :<, :>, :<=, :>=, :positive?, :negative?, :div, :divmod, :modulo, :%, :remainder, :abs, :zero?, :nonzero?, :coerce, :to => :volume
  
    def -@
      Box.new(*values.map {|v| -v}, unit)    
    end
  
    def ==(other_object)
      other_object = validate_box(other_object)
      length == other_object.length && width == other_object.width && height == other_object.height
    rescue
      false
    end

    def eql?(other_object)
      self == other_object
    end
  
    def +(other_object)
      other_object = validate_capacity_or_length(other_object)
      case other_object
      when Length, Volume then Box.new(*values.map {|v| v + other_object/3}, unit)
      when Box then Box.new(*VALUES.map {|v| eval(v) + other_object.send(v)}, unit)
      end
    end
  
    def -(other_object)
      other_object = validate_capacity_or_length(other_object)
      case other_object
      when Length, Volume then Box.new(*values.map {|v| v - other_object/3}, unit)
      when Box then Box.new(*VALUES.map {|v| eval(v) - other_object.send(v)}, unit)
      end
    end
  
    def *(other_object)
      other_object = validate_capacity_or_length(other_object)
      case other_object
      when Length, Volume then Box.new(*values.map {|v| v * other_object}, unit)
      when Box then Box.new(*VALUES.map {|v| eval(v) * other_object.send(v)}, unit)
      end
    end
  
    def /(other_object)
      other_object = validate_capacity_or_length(other_object)
      case other_object
      when Length, Volume then Box.new(*values.map {|v| v / other_object}, unit)
      when Box then Box.new(*VALUES.map {|v| eval(v) / other_object.send(v)}, unit)
      end
    end
    
    ### ARITHMETICS END ###
  
    def multiplicator(sum)
      GeneralUnits::Arithmetics.three_factors_of(sum).map do |v|
        Box.new(v[0]*length, v[1]*width, v[2]*height, unit)
      end
    end
  
    def multiply_to_strong_box(sum)
      multiplicator(sum).min_by {|box| box.values.max - box.values.min}
    end
    
    def multiply_to_optimal(sum)
      if sum.odd?
        [multiply_to_strong_box(sum-1), self]
      else
        [multiply_to_strong_box(sum)]
      end.compact
    end
    
    def concat_with(other_box, &block)
      length_1, width_1, height_1 = *values.sort.reverse
      length_2, width_2, height_2 = *other_box.values.sort.reverse

      x1 = (length_1 - length_2).abs
      length = [length_1, length_2].max

      x2 = (width_1 - width_2).abs
      width = [width_1, width_2].max

      height = height_1 + height_2

      if x1 > 0
        y1 = width
        z1 = length_1 > length_2 ? height_2 : height_1
        yield Box.new(x1, y1, z1)
      end

      if x2 > 0
        y2 = ((length_1 > length_2) && (width_1 > width_2)) ? length-x1 : length
        z2 = width_1 > width_2 ? height_2 : height_1
        yield Box.new(x2, y2, z2)
      end
      
      Box.new(length, width, height)
    end

    def estimated_spaces_with(other_box, &block)
      if includes?(other_box)
        length_1, width_1, height_1 = *values.sort.reverse
        length_2, width_2, height_2 = *other_box.values.sort.reverse
        
        estimated_spaces = []
        
        x1 = (length_1 - length_2).abs
        if x1 > 0
          space1 = Box.new(x1, width_1, height_1)
          estimated_spaces << space1
          yield space1
        end
  
        x2 = (width_1 - width_2).abs
        if x2 > 0
          space2 = Box.new(length_1 - x1, x2, height_1)
          estimated_spaces << space2
          yield space2
        end
  
        x3 = (height_1 - height_2).abs
        if x3 > 0
          space3 = Box.new(length_2, width_2, x3)
          estimated_spaces << space3
          yield space3
        end
        
        estimated_spaces
      end
    end
  
    private
  
    def validate_dimension_value(val, unit = nil)
      unit ||= :centimeter
      val.is_a?(Length) ? val.convert_to(unit) : Length.new(val, unit)
    end
  
    def validate_box(val)
      case val
      when Box then val.convert_to(unit)
      else raise(TypeError, "Box required, #{val.class} passed.")
      end
    end
  
    def validate_capacity_or_length(val)
      case val
      when Box then val.convert_to(unit)
      when Volume then val.convert_to(volume.unit.code)
      when Length, Numeric then val.to_volume(volume.unit.code)
      else raise(TypeError, "Box or Volume or Numeric required, #{val.class} passed.")
      end
    end
  
  end
  
end