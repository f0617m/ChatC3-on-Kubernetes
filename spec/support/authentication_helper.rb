module AuthenticationHelper
  extend ActiveSupport::Concern
  
  included do
    before do
      controller_mock = double('Controller mock')
      allow(controller_mock).to receive(:authenticate)

      allow(RoomsController).to receive(:authenticate).and_return(controller_mock)
    end
  end

  def authenticate
    return true
  end
end