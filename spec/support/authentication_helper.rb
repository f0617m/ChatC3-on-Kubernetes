module AuthenticationHelper
  extend ActiveSupport::Concern
  
  self.included do
    before do
      controller_mock = double('Controller mock')
      allow(controller_mock).to receive(:authenticate).and_return(true)

      allow(self).to receive(:authenticate).and_return(controller_mock)
    end
  end

  def authenticate
    return true
  end
end