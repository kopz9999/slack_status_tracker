require 'spec_helper'

describe SlackStatusTracker::Scrapper do
  describe '#retrieve_users' do
    let(:instance) {
      SlackStatusTracker::Scrapper.new(ENV['SLACK_USER'],
                                       ENV['SLACK_PASSWORD'],
                                       :chrome, 'codersclandev')
    }

    it 'get online users' do
      instance.retrieve_users
      expect(instance.current_online_users).to be >= 7
    end
  end
end
