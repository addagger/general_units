module GeneralUnits

  module ActionViewExtension
    extend ActiveSupport::Concern
  
    included do
    end

    def weight_units_for_select(*args)
      Weight.select_units(*args).map {|u| [u.to_s, u.code]}
    end
        
    def short_weight_units_for_select(*args)
      Weight.select_units(*args).map {|u| [u.to_s(:format => :short), u.code]}
    end

    def length_units_for_select(*args)
      Length.select_units(*args).map {|u| [u.to_s, u.code]}
    end
        
    def short_length_units_for_select(*args)
      Length.select_units(*args).map {|u| [u.to_s(:format => :short), u.code]}
    end
    
  end
  
end
