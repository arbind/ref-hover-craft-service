RUNNING_IN_CONSOLE = defined?(Rails::Console)
RUNNING_IN_RAKE_TASK = global_variables.include? "$rakefile"
RUNNING_IN_SERVER = ! ( RUNNING_IN_CONSOLE  or RUNNING_IN_RAKE_TASK)

puts ":: Running in server" if RUNNING_IN_SERVER
puts ":: Running in rake task" if RUNNING_IN_RAKE_TASK
puts ":: Running in console" if RUNNING_IN_CONSOLE

REDIS_LISTENERS = {}

def new_redis_connection(redis_url=nil)
  uri ||= URI.parse(redis_url.to_s || "redis://localhost:6379/" )
  Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

###
# To Test this:
# Launch in one console:
#   $ rails s
# Initialize Listener with browser:
#   visit: http://localhost:3000/root/initialize_listeners 
# Create events in another console:
#   $ rails c
#   > r = new_redis_connection
#   > r.RPUSH 'tweet', {action: 'eat', time:'2pm', data: 'bbq'}.to_json
##

# +++ TODO use ENV[REDIS_TWEET_URI] to listen to tweet server 
# +++ TODO use ENV[REDIS_YELP_URI] to listen to yelp server
def start_redis_listeners(channels_array, redis_url=nil)
  channels = *channels_array
  url = redis_url || ENV["REDIS_URI"] || ENV["REDISTOGO_URL"] || "redis://localhost:6379/"
  key = url.to_s + channels.to_s
  return if REDIS_LISTENERS[key].present?
  REDIS_LISTENERS[key] = Thread.new do
    Thread.current[:name] = :redis_listener
    Thread.current[:description] = "REDIS BLPOP #{[*channels].join(',')}, 0 [#{url.to_s}] "

    redis = nil # establish redis connection: 
    until redis.present? and redis.ping
      redis = new_redis_connection(url)
      if redis.nil?
        sleep 10
        puts "redis server not responding to ping [#{url.to_s}]"
      end
    end

    puts "Listener Thread Started: #{Thread.current[:description]}"
    loop do
      channel_element = redis.blpop *channels, 0
      channel = channel_element.first
      element = element = channel_element.last
      event = ( JSON.parse(element) rescue {} )
      # fire event on channel
      puts "#{channel}: do #{event['action']} at #{event['time']} with data #{event['data']}"
    end
  end
end

# ping the server to keep from idling out
# if RUNNING_IN_SERVER
#   puts ":: Initializing Ping Thread"
#   PING_URI = URI.parse("http://#{ENV['hostname']}/ping.json")
#   ping_thread = Thread.new do
#     Thread.current[:name] = :ping
#     Thread.current[:description] = "Pings server every 8 minutes"
#     loop do
#       sleep 8*60 # 8 minutes
#       Net::HTTP.get_response(PING_URI)
#     end
#   end
# else
#   puts ":: No Ping Thread Started"
# end
