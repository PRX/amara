module Amara

  class Error < ::StandardError
    attr_accessor :response

    def initialize(message = nil, response = nil)
      super(message || "Amara Error")
      self.response = response
    end
  end

  class ClientError   < Error; end
  class NotFoundError < Error; end
  class ServerError   < Error; end
  class UnknownError  < Error; end
end
