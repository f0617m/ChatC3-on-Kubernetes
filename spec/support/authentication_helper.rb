require 'rails_helper'

module AuthenticationHelper
  extend ActiveSupport::Concern
  
  self.included do
    before do
      controller_mock = double('Controller mock')
      it 'self test' do
        expect(self).to eq 'aiueo'

      end

      allow(controller_mock).to receive(:authenticate).and_return(true)

      allow(self).to receive(:authenticate).and_return(controller_mock)
    end
  end
end