module OAuth2
  class ErrorWithResponse < StandardError; attr_accessor :response end
  class AccessDenied < ErrorWithResponse; end
  class HTTPError < ErrorWithResponse; end
end
