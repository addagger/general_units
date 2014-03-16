require "general_units/version"

module GeneralUnits
  def self.load!
    load_units!
    load_numeric!
    load_derivatives!
    require 'general_units/engine'
    require 'general_units/railtie'
  end

  def self.load_units!
    require 'general_units/units/weight'
    require 'general_units/units/length'
  end
  
  def self.load_numeric!
    require 'general_units/numeric'
  end
  
  def self.load_derivatives!
    require 'general_units/derivatives/box'
  end

end

GeneralUnits.load!