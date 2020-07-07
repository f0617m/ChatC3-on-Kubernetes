module AuthenticationHelper
  extend ActiveSupport::Concern
  
  self.included do
    before do
      allow_any_instance_of(self).to receive(:authenticate)
    end
  end
end