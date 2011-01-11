# Load the models in Object scope.
Dir.glob(File.join PROJECT, 'models', '**', '*.rb').sort.each do |file|
  require file
end

class SinatraMVC
  # Load the app recursively.
  # We have to run the code in our SinatraMVC class. We'll be nice to
  # our developers and don't require them to open the class in every
  # app file.
  Dir.glob(File.join PROJECT, 'app', '**', '*.rb').sort.each do |file|
    # TODO I'm sure we can think of a better way to do this.
    self.class_eval File.new(file).read, file
  end

end
