require 'helper'

Hobby::Devtools::RSpec.describe do
  app { API.new }
  format JSON
end
