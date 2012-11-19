class RootController < ApplicationController
  def index
    @craft_count = Craft.count
  end

  def initialize_listeners
    puts "initializing listeners"
    # First non-empty channel that has an event will be served first
    # So the order in which these event channels are listed are important
    # eg: a materialize event will create the craft, a tweet or location event will update the craft ( if it exists )
    start_redis_listeners(['materialize-craft', 'tweet', 'craft-location', 'craft-reviews'])
    render json: {status: :ok}
  end

end
