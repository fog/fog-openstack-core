require "webmock"

class WebMock::HttpLibAdapters::ExconAdapter

  def self.request_params_from(hash)
    hash = hash.dup
    if Excon::VERSION >= '0.27.5'
      request_keys = Excon::VALID_REQUEST_KEYS
      hash.reject! { |key, _| !request_keys.include?(key) }
    end
    PARAMS_TO_DELETE.each { |key| hash.delete(key) }
    hash
  end

end