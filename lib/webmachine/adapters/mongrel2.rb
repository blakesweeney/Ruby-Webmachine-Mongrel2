require 'mongrel2'

module Webmachine
  module Adapters
    # An adapter to allow webmachine to work with Mongrel2. Doesn't currently
    # support streaming bodies.
    module Mongrel2

      SERVER = Webmachine::SERVER_STRING + "  " + ::Mongrel2.version_string(true)

      def self.run
        config = Webmachine.configuration.adapter_options
        ::Mongrel2::Config.configure(:configdb => config[:database])
        Webmachine::Adapters::Mongrel2::Handler.run(config[:handler_id])
      end

      class Handler < ::Mongrel2::Handler
        def handle(request)
          web_request = webmachine_request(request)
          web_response = Webmachine::Response.new
          Webmachine::Dispatcher.dispatch(web_request, web_response)
          return mongrel_response(request, web_response)
        end

        private
          def mongrel_response(request, web_response)
            mongrel_response = request.response
            web_response.headers.each do |key, value|
              mongrel_response.headers[key] = value
            end
            mongrel_response.headers['Server'] = SERVER
            mongrel_response.status = web_response.code
            mongrel_response.puts web_response.body
            return mongrel_response
          end

          def webmachine_request(request)
            headers = Webmachine::Headers.new
            request.headers.each do |key, value|
              headers[key] = value
            end
            uri = URI.parse(request.headers.uri)
            method = request.headers[:method]
            body = request.body
            return ::Webmachine::Request.new(method, uri, headers, body)
          end
      end
    end
  end
end
