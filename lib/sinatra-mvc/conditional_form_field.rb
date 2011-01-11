class SinatraMVC
  helpers do
    # Simple helper to display form field data when available.
    # It prefers params, but when unavailable it'll use the supplied object (if available).
    def c(field, object = nil)
      if params.has_key? field.to_s
        h params[field.to_s]
      elsif object.respond_to? field
        h object.send(field)
      else
        ""
      end
    end
  end
end
