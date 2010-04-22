module OAuth2
  module ServerStrategy
    class Memory < Base
      def initialize(options = {})
        @apps   = options[:apps]   || {}
        @tokens = options[:tokens] || {}
      end

      def app_for(client)
        app = @apps[client.id]
      end

      def temporary_code_for(client, options = {})
        if app = app_for(client)
          app.code!(options)
        end
      end

      def access_token_for(client, options = {})
        if app = app_for(client)
          if code_options = app.codes.delete(client.options[:code])
            app.token!(code_options.update(options))
          end
        end
      end

      def access_token_options(token)
        @tokens[token]
      end

      attr_reader :apps, :tokens

      class App
        attr_reader :id, :secret, :redirect_uri, :codes, :tokens
        def initialize(server, options = {})
          @server       = server
          @id           = options[:id]           || Server.random_string(16)
          @secret       = options[:secret]       || Server.random_string(40)
          @redirect_uri = options[:redirect_uri] || 'http://example.com/oauth/callback'
          @codes        = options[:codes]        || {} # key => {}
        end

        def code!(options = {})
          id = Server.random_string(16)
          @codes[id] = options
          id
        end

        def token!(options = {})
          id = Server.random_string(40)
          @server.tokens[id] = options.update(:app => self)
          id
        end
      end

      def app!(options = {})
        a = App.new(self, options)
        @apps[a.id] = a
      end
    end
  end
end