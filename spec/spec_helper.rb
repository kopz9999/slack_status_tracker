$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'slack_status_tracker'
require "pry"

Dir["#{SlackStatusTracker.root}/spec/support/**/*.rb"].each { |f| require f }
