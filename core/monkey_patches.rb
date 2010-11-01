# Monkey patches are extensions to the Ruby base classes.
# Kind of useful, but not that nice.

class String
  # Escape HTML
  def html
    Rack::Utils.escape_html self
  end
end
