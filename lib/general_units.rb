require "general_units/version"

module GeneralUnits
  def self.load!
    load_arithmetics!
    load_units!
    load_numeric!
    load_derivatives!
    # load_locales!
    require 'general_units/engine'
    require 'general_units/railtie'
  end

  def self.load_arithmetics!
    require 'general_units/arithmetics/methods'
  end

  def self.load_units!
    require 'general_units/units/base/measurement'
    require 'general_units/units/base/unit'
    require 'general_units/units/weight'
    require 'general_units/units/length'
    require 'general_units/units/volume'
  end
  
  def self.load_numeric!
    require 'general_units/numeric'
  end
  
  def self.load_derivatives!
    require 'general_units/derivatives/box'
  end
  
  # def load_locales!
  #   Dir[File.join(File.dirname(__FILE__), "russian", "locale", "**/*")]
  # end

end

GeneralUnits.load!