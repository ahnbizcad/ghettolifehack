class TweetsController < ApplicationController

  def new(content)
    client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = "YOUR_CONSUMER_KEY"
      config.consumer_secret     = "YOUR_CONSUMER_SECRET"
      config.access_token        = "YOUR_ACCESS_TOKEN"
      config.access_token_secret = "YOUR_ACCESS_SECRET"
    end
    twitter_client.update(content)
  end

  def create

  end

end