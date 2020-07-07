module AuthenticationHelper
  extend ActiveSupport::Concern
  
  included do
    before do
      controller_mock = double('Controller mock')
      allow(controller_mock).to receive(:authenticate)

      allow(self).to receive(:authenticate).and_return(controller_mock)
    end
  end

  def authenticate
    return true
  end

  def authenticate_or_request_with_http_token
    return true
  end
end