module GeneralUnits

  module ActionViewExtension
    extend ActiveSupport::Concern
  
    included do
    end
    
    def weight_units_for_select
      Weight::UNITS.map {|u| [u.name, u.code]}
    end
    
    def length_units_for_select
      Length::UNITS.map {|u| [u.name, u.code]}
    end
    
  end
  
end
