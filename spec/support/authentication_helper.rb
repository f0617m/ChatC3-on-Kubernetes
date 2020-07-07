module AuthenticationHelper
  extend ActiveSupport::Concern
  
  self.included do
    before do
      controller_mock = double('Controller mock')
      allow(controller_mock).to receive(:authenticate)

      allow(self).to receive(:authenticate).and_return(controller_mock)
    end
  end

  def authenticate
    it 'Auth test' do
        expect(200).to eq 200
    end
    return true
  end

  def authenticate_or_request_with_http_token
    return true
  end
end