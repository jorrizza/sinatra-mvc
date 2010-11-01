# Provides a messaging service using the session.
# You might use it for telling the user she sucks at providing input, for instance.

helpers do
  # If it's called without text, it will return an array with the active messages,
  # for that type. The active messages for that type will then be cleared.
  # If it's called with :format, "text", text will be added to the messages of :format.
  # You can use :info, :warning and :error types.
  def after_post_message(type, text = nil)
    raise ArgumentError unless [:info, :error].include? type

    unless $_session['after_post_message']
      $_session['after_post_message'] = {
        :info => [],
        :error => []
      }
    end
    
    if text
      $_session['after_post_message'][type] << text
    else
      ret = $_session['after_post_message'][type].dup
      $_session['after_post_message'][type] = []
      ret
    end
  end
end
