class ScraperCollectJob < ApplicationJob
  queue_as :default

  def perform(*args)
    TweetFetcherService.new.perform
  end
end
