# Simple helper to display form field data when available

helpers do
  def c(field)
    if params.has_key? field
      params[field].html
    else
      ""
    end
  end
end
