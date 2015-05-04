class Params
  # uses initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @req = req
    @params = route_params
    parse_www_encoded_form(@req.body)
    parse_www_encoded_form(@req.query_string)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json.to_s
  end

  private
  # returns a deeply nested hash
  # Example:
  # user[address][street]=main&user[address][zip]=89436
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    return nil if www_encoded_form.nil?
    kv_pairs = URI::decode_www_form(www_encoded_form)
    # [["user[address][street]", "main"], ["user[address][zip]", "89436"]]
    kv_pairs.each do |key_array, value|
      current_node = @params
      key_array = parse_key(key_array)
      key_array.each_with_index do |key, idx|
        if idx == (key_array.length - 1)
          current_node[key] = value
        else
          if !current_node[key].is_a?(Hash)
            current_node[key] = {}
          end
            current_node = current_node[key]
        end
      end
    end
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
