# Singleton
require "singleton"
require "watir"
require 'headless'
# App
require "slack_status_tracker/version"
require "slack_status_tracker/report_manager"
require "slack_status_tracker/scrapper"

module SlackStatusTracker
  def self.root
    File.expand_path '../..', __FILE__
  end
end
