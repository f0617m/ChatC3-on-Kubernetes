module AuthenticationHelper
  extend ActiveSupport::Concern
  
  self.included do
    before do
      allow(self).to receive(:authenticate)
    end
  end

  def authenticate
    return true
  end
end