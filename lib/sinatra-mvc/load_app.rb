# Loads the app recursively.
# It does this by first loading all of the models and then
# the controllers (app components if you will).

def load_app(dir)
  Dir.glob(File.join PROJECT, dir, '**', '*.rb').sort.each do |file|
    load file
  end
end

load_app 'models'
load_app 'app'
