module AuthenticationHelper
  extend ActiveSupport::Concern
  
  self.included do
    before do
      allow(self).to receive(:authenticate).and_return(true)
    end
  end
end