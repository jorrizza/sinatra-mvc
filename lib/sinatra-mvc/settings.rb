# Loads the settings

require 'psych'

class SinatraMVC
  # The settings loading class. It pretty much takes care of loading
  # the settings from your project's settings.yml file.
  class Settings

    # Loads the settings file and populates the Settings class.
    # Later, these settings will be passed into Sinatra's set().
    def self.load(filename)
      begin
        @@settings = Psych.load_file filename
      rescue
        raise 'Could not load configuration! Psych said: ' + $!.to_s
      end
    end

    # Public class attr_reader of the settings.
    # It's just the output of Psych.load_file, really.
    def self.settings
      @@settings
    end
  end

  Settings.load File.join(PROJECT, 'conf', 'settings.yml')

  # Now we have to feed the Sinatra settings
  Settings.settings.each_pair do |setting, value|
    case setting
    when 'views_root', 'translations', 'public'
      set setting.to_sym, File.join(PROJECT, value)
    else
      set setting.to_sym, value
    end
  end
end
