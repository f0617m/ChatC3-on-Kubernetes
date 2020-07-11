require 'rails_helper'

module AuthenticationHelper
  # token認証のスキップ
  def authenticateMock(obj)
    controller_mock = double('Controller mock')
    allow(controller_mock).to receive(:authenticate).and_return(true)

    allow(obj).to receive(:authenticate).and_return(controller_mock)
  end
end