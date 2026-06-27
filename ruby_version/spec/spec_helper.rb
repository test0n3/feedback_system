# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative '../config/application'
require_relative '../app'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    App
  end

  # Reset DB before each test
  config.before :each do
    Feedback.delete_all # clear all feedback records
  end
end
