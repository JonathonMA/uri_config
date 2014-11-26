require 'uri'
require 'cgi'

module URIConfig
  class Config
    def initialize(url)
      @url = url
    end

    def self.map(key, options = {})
      alias_method key, options.fetch(:from)
    end

    def username
      CGI.unescape uri.user
    end

    def password
      CGI.unescape uri.password
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
        keys.each_with_object({}) do |key, hash|
          hash[key] = send(key)
        end
      end
    end

    private

    def query
      CGI.parse(uri.query || '')
    end

    def uri
      @uri ||= URI.parse @url
    end
  end
end
