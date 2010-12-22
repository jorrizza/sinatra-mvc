# Loads the settings

require 'psych'

class Settings
  def self.load(filename)
    begin
      @@settings = Psych.load_file filename
    rescue
      raise 'Could not load configuration! Psych said: ' + $!.to_s
    end
  end

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
