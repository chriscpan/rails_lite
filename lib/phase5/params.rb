require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @req = req
      @params = route_params
      p route_params
      parse_www_encoded_form(@req.body)
      parse_www_encoded_form(@req.query_string)
    end

    def [](key)
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
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
end
