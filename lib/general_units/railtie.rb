require 'rails'

module GeneralUnits
  class Railtie < ::Rails::Railtie
    config.i18n.load_path += Dir[ File.join(File.dirname(__FILE__), 'locales', '**', '*.{rb,yml}') ]
    config.before_initialize do
      ActiveSupport.on_load :active_record do
        require 'general_units/models/active_record_extension'
        include ActiveRecordExtension
      end
      ActiveSupport.on_load :action_view do
        require 'general_units/helpers/action_view_extension'
        include ActionViewExtension
      end
    end

  end
end