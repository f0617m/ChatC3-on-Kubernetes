require 'rails_helper'

module AuthenticationHelper
  extend ActiveSupport::Concern
  
  self.included do
    describe 'self test' do
      it 'self test2' do
        expect(self).to eq 'aiueo'
      end
    end

    before do
      controller_mock = double('Controller mock')
      allow(controller_mock).to receive(:authenticate).and_return(true)

      allow(self).to receive(:authenticate).and_return(controller_mock)
    end
  end
end