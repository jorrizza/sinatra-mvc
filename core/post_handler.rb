# Utility functions to handle POST data.
# TODO: Write post_object_multi for field[] input fields

helpers do
  # Create or modify a single object from POST data.
  # We assume the programmer isn't stupid, and actually provided a DataMapper class or object as the first argument.
  # The second and third arguments supply a redirection mechanism on succes and failure. By default it's the
  # referer. When nil, no redirection will take place.
  def post_object_single(input,
                         the_way_forward = request.env['HTTP_REFERER'],
                         the_way_back = request.env['HTTP_REFERER'])

    # Get the proper object and class.
    if input.is_a? DataMapper::Resource
      the_object = input
      the_class = the_object.class
    else
      the_class = input
      the_object = the_class.new
    end
    
    # Check for each parameter if we've got a model field
    # and call the setter for that field and redirect.
    params.each do |field, value|
      method = (field + '=').to_sym
      if the_object.respond_to? method
        the_object.send(method, value)
      end
    end

    # If the object's valid, save and redirect. If not, show all the errors to the user
    # at the way back location. We also make sure the same error doesn't show twice.
    if the_object.valid?
      the_object.save
      redirect the_way_forward unless the_way_forward.nil?
    else
      flash[:error] = []
      found_errors = []
      the_object.errors.each_pair do |field, error|
        field = field.to_s
        field.gsub! /_id$/, ''
        error.each do |e|
          unless found_errors.include? [field, error]
            flash[:error] << t[the_class.inspect.downcase.to_sym][field.to_sym] + ': ' + e
            found_errors << [field, error]
          end
        end
      end
      redirect the_way_back unless the_way_back.nil?
    end
  end
  
end
