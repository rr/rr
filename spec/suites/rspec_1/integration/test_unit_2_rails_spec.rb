require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../common/rails_integration_test', __FILE__)

describe 'Integration between TestUnit and Rails' do
  def bootstrap
    <<-EOT
      RAILS_ROOT = File.expand_path(__FILE__)
      require 'rubygems'
      require 'rack'
      require 'test/unit'
      require 'active_support/all'
      require 'action_controller'
      require 'active_support/test_case'
    EOT
  end
end
