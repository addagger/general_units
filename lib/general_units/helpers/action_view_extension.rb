module GeneralUnits

  module ActionViewExtension
    extend ActiveSupport::Concern
  
    included do
    end
    
    def weight_units_for_select
      Weight.units.map {|u| [u.name, u.code]}
    end
    
    def length_units_for_select
      Length.units.map {|u| [u.name, u.code]}
    end
    
  end
  
end
