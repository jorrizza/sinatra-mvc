# This will enable neat parameters like Rails and PHP have.
# You know, the variable[key] things.
# From the Sinatra book.

class SinatraMVC
  before do
    new_params = {}
    params.each_pair do |full_key, value|
      this_param = new_params
      split_keys = full_key.split(/\]\[|\]|\[/)
      split_keys.each_index do |index|
        break if split_keys.length == index + 1
        this_param[split_keys[index]] ||= {}
        this_param = this_param[split_keys[index]]
      end
      this_param[split_keys.last] = value
    end
    request.params.replace new_params
  end
end
