require 'uri'
require 'cgi'

module URIConfig
  class Config
    FETCH_ERROR = (RUBY_VERSION < "1.9" ? ::IndexError : ::KeyError)

    def initialize(url)
      @url = url
    end

    def self.map(key, options = {})
      alias_method key, options.fetch(:from)
    end

    def self.parameter(method, query_parameter = method)
      define_method(method) do
        query[query_parameter.to_s].first
      end
    end

    def self.configure_from(env_var, &block)
      configure_from!(env_var, &block)
    rescue FETCH_ERROR
      nil
    end

    def self.configure_from!(env_var)
      config = new ENV.fetch(env_var)

      if block_given?
        yield config
      else
        config
      end
    end

    def self.values_from(env_var, *params)
      config = configure_from!(env_var)

      params.map { |param| config.public_send(param) }
    end

    def ==(other)
      return false unless other.is_a?(self.class)

      url == other.url
    end

    def username
      CGI.unescape uri.user if uri.user
    end

    def password
      CGI.unescape uri.password if uri.password
    end

    def host
      uri.host
    end

    def port
      uri.port
    end

    def path
      uri.path
    end

    def base_uri
      uri.dup.tap do |uri|
        uri.user = nil
        uri.password = nil
      end.to_s
    end

    def self.config(*keys)
      define_method :config do
        keys.
          inject({}) do |hash, key|
            hash[key] = send(key)
            hash
          end.
          reject { |_, value| value.nil? }
      end
    end

    protected

    attr_reader :url

    private

    def query
      CGI.parse(uri.query || '')
    end

    def uri
      @uri ||= URI.parse url
    rescue URI::InvalidURIError
      raise URI::InvalidURIError, "Invalid URI: <URL_SUPPRESSED>"
    end
  end
end
