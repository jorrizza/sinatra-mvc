# Simple helper to display form field data when available.
# It prefers params, but when unavailable it'll use the supplied object (if available).

helpers do
  def c(field, object = nil)
    if params.has_key? field.to_s
      params[field.to_s].html
    elsif object.respond_to? field
      object.send(field).html
    else
      ""
    end
  end
end
