module OAuth2
  module ServerStrategy
    def self.load(options = {})
      if options.is_a?(ServerStrategy::Base)
        options
      elsif options.nil? || options.blank?
        ServerStrategy::Memory.new
      elsif klass = options.delete(:class)
        klass.new(options)
      end
    end

    autoload :Memory, 'oauth2/server_strategy/memory'

    class Base #:nodoc:
      def initialize(options = {})#:nodoc:
      end

      def app_for(client)
      end

      def temporary_code_for(client, options = {})
      end

      def access_token_for(client, options = {})
      end

      def access_token_options(token)
      end
    end
  end
end