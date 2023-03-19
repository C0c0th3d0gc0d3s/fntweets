class TweetFetcherService
    TWITTER_URL = "https://twitter.com/FortniteGame"

    def perform
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument("--enable-javascript")
        driver = Selenium::WebDriver.for(:chrome, options: options)
        driver.get TWITTER_URL

        wait = Selenium::WebDriver::Wait.new(timeout: 30)
        begin
            wait.until { driver.find_elements(css: '[data-testid^="tweet"]').size >= 10 }
        rescue Selenium::WebDriver::Error::TimeOutError
            puts "Tweets did not appear!"
        end

        sleep 2

        document = Nokogiri::HTML(driver.page_source)

        tweet_elements = document.css('[data-testid="tweet"]')
        tweet_elements.each do |element|
            # ID
            tweet_id = element.at('a[href*="/status/"]')["href"].split("/").last

            # Text
            text = element.css('[data-testid="tweetText"]').text

            # Image/Video
            e = element.css('[data-testid="tweetPhoto"]')[0].children[0]

            image_src = e.attributes['style']&.value&.match(/url\("(.+)"\)/)
            image_url = image_src ? image_src[1] : nil

            video_src = e.css("[src]")[0]
            video = video_src ? video_src.attributes["src"]&.value : nil

            # Author name
            author_name = element.css('[data-testid="User-Names"]').text.split("·")[0]

            # Author avatar
            e = element.css('[data-testid="Tweet-User-Avatar"] [style^="background-image"]')[0]
            avatar_url = e["style"].match(/url\("(.+)"\)/)[1]

            # Posting date
            posting_date = element.css("[datetime]")[0]["datetime"]

            tweet = Tweet.find_or_initialize_by(external_id: tweet_id)
            tweet.text = text
            tweet.author_name = author_name
            tweet.author_avatar_url = avatar_url
            tweet.posting_date = posting_date
            tweet.image_url = image_url
            tweet.video = video
            tweet.save!
        end

        # Close the browser window
        driver.quit
    end
end
