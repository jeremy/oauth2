require 'oauth2/server_strategy/base'

module OAuth2
  class Server
    attr_reader   :strategy
    attr_accessor :id, :options

    # Options:
    # <tt>:type</tt>
    # <tt>:redirect_uri</tt>
    # <tt>:client_secret</tt>
    # <tt>:code</tt>
    # <tt>:scope</tt>
    def initialize(client_id, options = {})
      @id       = client_id
      @strategy = ServerStrategy.load(options.delete(:strategy))
      @options  = options
    end

    def temporary_code(options = {})
      @options[:code] || @strategy.temporary_code_for(self, options)
    end

    def access_token(options = {})
      @strategy.access_token_for(self, options)
    end

    # ActiveSupport's implementation optionally uses win32 api.
    # Only attempt to use it if it's already loaded.
    if defined?(ActiveSupport::SecureRandom)
      def self.random_string(n = 16)
        ActiveSupport::SecureRandom.hex(n)
      end
    else
      require 'securerandom'
      def self.random_string(n = 16)
        SecureRandom.hex(n)
      end
    end
  end
end