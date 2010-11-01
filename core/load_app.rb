# Loads the app recursively.
# It does this by first loading all of the models and then
# the controllers (app components if you will).

def load_app(dir)
  Dir.new(dir).each do |file|
    unless ['.', '..'].include? file
      this_file = dir + '/' + file

      if File.directory? this_file
        load_app this_file
      elsif File.extname(this_file) == '.rb'
        load this_file
      end
    end
  end
end

load_app 'models'
load_app 'app'
