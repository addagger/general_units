class Numeric

  def to_weight(unit = :gram)
    GeneralUnits::Weight.new(self, unit)
  end
  
  def to_length(unit = :millimeter)
    GeneralUnits::Length.new(self, unit)
  end

end