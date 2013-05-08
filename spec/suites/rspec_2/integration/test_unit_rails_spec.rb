require File.expand_path('../../../common/rails_integration_test', __FILE__)

describe 'Integration between TestUnit and Rails' do
  def bootstrap
    <<-EOT
      require 'rubygems'
      require 'test/unit'
      require 'rails'
      require 'active_support'
    EOT
  end
end
