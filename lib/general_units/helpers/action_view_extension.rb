module GeneralUnits

  module ActionViewExtension
    extend ActiveSupport::Concern
  
    included do
    end
    
    def weight_units_for_select
      Weight::UNITS.map {|k,v| [v, k]}
    end
    
    def length_units_for_select
      Length::UNITS.map {|k,v| [v, k]}
    end
    
  end
  
end
