class TweetsController < ApplicationController

  def tweet
    twitter_client.update("wer")
  end

end