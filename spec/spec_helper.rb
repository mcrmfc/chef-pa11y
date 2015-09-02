require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.log_level = :error
  config.platform = 'centos'
  config.version = '6.4'
end
