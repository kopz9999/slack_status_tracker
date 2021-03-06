module SlackStatusTracker
  class ReportManager
    include Singleton

    attr_accessor :output_path
    attr_accessor :json_hash

    def cmd
      options = parse_options ARGV
      set_output options
      set_json_hash options
      frequency = options.fetch :frequency
      append_to_output "Time\t\t\t\tOnline Users"
      if options[:start]
        while true
          verify_options options
          sleep frequency*60
        end
      else
        verify_options options
      end
    end

    def verify_options(options = {})
      if self.json_hash.nil?
        process_options options
      else
        process_json options
      end
    end

    def process_json(options)
      driver = options.fetch :driver
      total = 0
      time = Time.now

      self.json_hash[:channels].each do |channel_hash|
        scrapper = SlackStatusTracker::Scrapper.new(channel_hash[:username],
                                                    channel_hash[:password],
                                                    driver,
                                                    channel_hash[:name])
        begin
          scrapper.retrieve_users
          total += scrapper.current_online_users
        rescue => e
          puts e.backtrace
        end
      end
      append_to_output "#{time}\t#{total}"
    end

    def process_options(options = {})
      channels = options.fetch :channels
      username = options.fetch :username
      password = options.fetch :password
      driver = options.fetch :driver
      total = 0
      time = Time.now

      channels.each do |c|
        scrapper = SlackStatusTracker::Scrapper.new(username, password,
                                                    driver, c)
        begin
          scrapper.retrieve_users
          total += scrapper.current_online_users
        rescue => e
          puts e.backtrace
        end
      end
      append_to_output "#{time}\t#{total}"
    end

    def parse_options(args)
      options = { frequency: 30, driver: :chrome }
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: slack_status_tracker [options]"

        opts.on("-s", "--start", "Start to track") do |s|
          options[:start] = true
        end

        opts.on("-o", "--output [FILE_PATH]",
                "Output file (default slack_online_users.txt)") do |o|
          options[:output] = o
        end

        opts.on("-i", "--input [FILE_PATH]",
                "JSON file with credentials about channels") do |i|
          options[:input] = i
        end

        opts.on("--channels c1,c2,c3", Array,
                "Slack channels") do |channels|
          options[:channels] = channels
        end

        opts.on("--driver [BROWSER_DRIVER]", String,
                "Browser Driver (default chrome)") do |d|
          options[:driver] = d.to_sym
        end

        opts.on("-f", "--frequency [MINUTES]", Integer,
                "Time minutes frequency (default 30)") do |f|
          options[:frequency] = f || FREQUENCY
        end

        opts.on("-u", "--username USERNAME", "Slack Username") do |u|
          options[:username] = u
        end

        opts.on("-p", "--password PASSWORD", "Slack Password") do |p|
          options[:password] = p
        end

        opts.separator ""
        opts.separator "Common options:"

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("--version", "Show version") do
          puts SlackStatusTracker::VERSION
          exit
        end
      end
      opt_parser.parse!(args)
      options
    end

    protected

    def append_to_output(content)
      puts content
      open(self.output_path, 'a') { |f| f.puts content }
    end

    def set_output(options)
      self.output_path = options[:output]
      if self.output_path.nil?
        self.output_path = File.join(Dir.pwd, 'slack_online_users.txt')
      end
    end

    def set_json_hash(options)
      if (input_path = options[:input])
        self.json_hash =
          JSON.parse(File.read(input_path), symbolize_names: true)
      end
    end
  end
end
