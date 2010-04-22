module OAuth2
  module ServerStrategy
    class Memory < Base
      class App
        attr_reader :id, :secret, :redirect_uri, :codes, :tokens
        def initialize(options = {})
          @id           = options.delete(:id)           || Server.random_string(16)
          @secret       = options.delete(:secret)       || Server.random_string(40)
          @redirect_uri = options.delete(:redirect_uri) || 'http://example.com/oauth/callback'
          @codes        = options.delete(:codes)        || {} # key => {}
          @tokens       = options.delete(:tokens)       || {} # key => {}
        end

        def code!(options = {})
          id = Server.random_string(16)
          @codes[id] = options
          id
        end

        def token!(options = {})
          id = Server.random_string(40)
          @tokens[id] = options
          id
        end
      end

      def initialize(options = {})
        super
        @apps = options[:apps] || {}
      end

      def temporary_code_for(client, options = {})
        super
        if app = @apps[client.id]
          app.code!(options)
        end
      end

      def access_token_for(client, options = {})
        super
        if app = @apps[client.id]
          if code_options = app.codes.delete(client.options[:code])
            app.token!(code_options.update(options))
          end
        end
      end

      def app!(options = {})
        a = App.new(options)
        @apps[a.id] = a
      end
    end
  end
end