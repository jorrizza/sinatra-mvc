# Simple helper to display form field data when available

helpers do
  def c(field)
    if params.has_key? field.to_s
      params[field.to_s].html
    else
      ""
    end
  end
end
