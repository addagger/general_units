require 'general_units/units/length'

module GeneralUnits
  
  class Box
  
    VALUES = %w{length width height}
  
    attr_reader *VALUES, :unit
  
    def initialize(length = 0, width = 0, height = 0, unit)
      VALUES.each {|v| instance_variable_set(:"@#{v}", validate_value(eval(v), unit))}
      @unit = @height.unit
    end
  
    def values
      VALUES.map {|v| self.send(v)}
    end
  
    def amount
      length * width * height
    end
  
    def convert_to(unit)
      Box.new(*values.map {|v| v.convert_to(unit).amount}, unit)
    end

    def to_s(round = 2)
      "#{values.map(&:to_f).map {|f| f.round(round)}.join("x")} #{unit.short}"
    end
    
    def accommodates?(*boxes)
      boxes.map! {|box| validate_capacity(box)}
      boxes.sum(&:amount) < amount && includes?(Box.new(boxes.map(&:length).max, boxes.map(&:width).max, boxes.map(&:height).max, unit))
    end
  
    def same_size?(other_object)
      other_object = validate_capacity(other_object)
      eval VALUES.permutation.to_a.map {|values_names| "(length == other_object.#{values_names[0]} && width == other_object.#{values_names[1]} && height == other_object.#{values_names[2]})"}.join("||")
    end
  
    def includes?(other_object)
      other_object = validate_capacity(other_object)
      eval VALUES.permutation.to_a.map {|values_names| "(length >= other_object.#{values_names[0]} && width >= other_object.#{values_names[1]} && height >= other_object.#{values_names[2]})"}.join("||")
    end
  
    ### ARITHMETICS START ###
  
    def -@
      Box.new(*values.map {|v| -v}, unit)    
    end
  
    def ==(other_object)
      other_object = validate_capacity(other_object)
      length == other_object.length && width == other_object.width && height == other_object.height
    end

    def eql?(other_object)
      self == other_object
    end

    def <=>(val)
      other_object = validate_capacity_or_length(other_object)
      amount <=> case other_object
      when Length then other_object
      when Box then other_object.amount
      end
    end

    def >(other_object)
      other_object = validate_capacity_or_length(other_object)
      amount > case other_object
      when Length then other_object
      when Box then other_object.amount
      end
    end
 
    def <(other_object)
      other_object = validate_capacity_or_length(other_object)
      amount < case other_object
      when Length then other_object
      when Box then other_object.amount
      end
    end
  
    def >=(other_object)
      other_object = validate_capacity_or_length(other_object)
      amount >= case other_object
      when Length then other_object
      when Box then other_object.amount
      end
    end
 
    def <=(other_object)
      other_object = validate_capacity_or_length(other_object)
      amount <= case other_object
      when Length then other_object
      when Box then other_object.amount
      end
    end

    delegate :positive?, :negative?, :to => :amount
  
    def +(other_object)
      other_object = validate_capacity_or_length(other_object)
      case other_object
      when Length then Box.new(*values.map {|v| v + other_object/3}, unit)
      when Box then Box.new(*VALUES.map {|v| eval(v) + other_object.send(v)}, unit)
      end
    end
  
    def -(other_object)
      other_object = validate_capacity_or_length(other_object)
      case other_object
      when Length then Box.new(*values.map {|v| v - other_object/3}, unit)
      when Box then Box.new(*VALUES.map {|v| eval(v) - other_object.send(v)}, unit)
      end
    end
  
    def *(other_object)
      other_object = validate_capacity_or_length(other_object)
      case other_object
      when Length then Box.new(*values.map {|v| v * other_object}, unit)
      when Box then Box.new(*VALUES.map {|v| eval(v) * other_object.send(v)}, unit)
      end
    end
  
    def /(other_object)
      other_object = validate_capacity_or_length(other_object)
      case other_object
      when Length then Box.new(*values.map {|v| v / other_object}, unit)
      when Box then Box.new(*VALUES.map {|v| eval(v) / other_object.send(v)}, unit)
      end
    end
  
    delegate :div, :divmod, :modulo, :%, :remainder, :abs, :zero?, :nonzero?, :coerce, :to => :amount
  
    ### ARITHMETICS END ###
  
    private
  
    def validate_value(val, unit)
      val.is_a?(Length) ? val.convert_to(unit) : Length.new(val, unit)
    end
  
    def validate_capacity(val)
      case val
      when Box then val.convert_to(unit)
      else raise(TypeError, "Box required, #{val.class} passed.")
      end
    end
  
    def validate_capacity_or_length(val)
      case val
      when Box, Length then val.convert_to(unit)
      when Numeric then val.to_length(unit)
      else raise(TypeError, "Box or Length or Numeric required, #{val.class} passed.")
      end
    end
  
  end
  
end