module SlackStatusTracker
  class Scrapper
    attr_accessor :browser
    attr_accessor :username
    attr_accessor :password
    attr_accessor :channel
    attr_accessor :current_online_users

    def initialize(username, password, driver, channel)
      self.username = username
      self.password = password
      self.channel = channel
      headless = Headless.new
      headless.start
      self.browser = Watir::Browser.new driver
      self.current_online_users = 0
    end

    def retrieve_users
      init_slack
      login
      init_team
      read_list
      browser.close
      headless.destroy
    end

    protected

    def read_list
      browser.element(css: '#active_members_list').wait_until_present
      browser.elements(css: '#active_members_list .team_list_item').each do |el|
        presence_bubble = el.element(css: 'span.presence')
        if presence_bubble.attribute_value("class").split(' ').include? 'active'
          self.current_online_users+=1
        end
      end
    end

    def init_slack
      self.browser.goto "https://#{self.channel}.slack.com/"
    end

    def login
      self.browser.text_field(:css => '#email').value = self.username
      self.browser.text_field(:css => '#password').set self.password
      self.browser.button(:css => '#signin_btn').click
    end

    def init_team
      browser.wait_until{ browser.url.include?("/messages") }
      self.browser.goto "https://#{self.channel}.slack.com/team"
    end
  end
end
