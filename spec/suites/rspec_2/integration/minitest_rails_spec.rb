require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/rails_integration_test', __FILE__)

describe 'Integration between MiniTest and Rails' do
  include IntegrationWithRails

  def bootstrap
    <<-EOT
      require 'rubygems'
      require 'minitest/unit'
      require 'rails'
      require 'active_support'
    EOT
  end
end
