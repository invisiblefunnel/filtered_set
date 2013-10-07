$:.push '../lib'
require 'filtered_set'

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
