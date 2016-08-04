# SlackStatusTracker

Command line tool to get the number of online users in Slack at a given time.
This tool is a scrapper based on [Watir](https://github.com/watir/watir).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slack_status_tracker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slack_status_tracker

## Usage

To ensure the command line tool is installed, run the following command:

    $ slack_status_tracker -h

You should get the available options:

```bash
Usage: slack_status_tracker [options]
    -s, --start                      Start to track
    -o, --output [FILE_PATH]         Output file (default slack_online_users.txt)
    -i, --input [FILE_PATH]          JSON file with credentials about channels
        --channels c1,c2,c3          Slack channels
        --driver [BROWSER_DRIVER]    Browser Driver (default chrome)
    -f, --frequency [MINUTES]        Time minutes frequency (default 30)
    -u, --username USERNAME          Slack Username
    -p, --password PASSWORD          Slack Password

Common options:
    -h, --help                       Show this message
        --version                    Show version
```

### One time output

The expected results are going to be printed in the command line and saved to 
a file named slack_online_users.txt, which should be located in the same path 
you ran the command:
```bash
slack_status_tracker -u slack_username -p slack_password --channels channel_1
```
Output:
```bash
Time                            Online Users
2016-08-01 09:00:55 +0000       11
```

### Daemon

Just append the -s option to keep it running every n minutes you want 
(by default 30):

```bash
slack_status_tracker -s -u slack_username -p slack_password --channels channel_1
```
Output:
```bash
Time                            Online Users
2016-08-01 09:00:55 +0000       11
```

For every 10 min

```bash
slack_status_tracker -s -u slack_username -p slack_password --channels channel_1
-f 10
```
Output:
```bash
Time                            Online Users
2016-08-01 09:00:55 +0000       11
```

### Multiple channels
In order to support multiple channels you need to pass a JSON configuration 
file with the username and password for each channel. Specify the path to the 
file with the proper settings.

```json
// spec/fixtures/sample_input.json 
{
  "channels": [
    {
      "name": "channel 1",
      "username": "user1",
      "password": "secret1"
    },
    {
      "name": "channel 2",
      "username": "user2",
      "password": "secret2"
    }
  ]
}
```

```bash
slack_status_tracker -i spec/fixtures/sample_input.json
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/slack_status_tracker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

