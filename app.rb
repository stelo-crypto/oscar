require 'rubygems'
require 'yaml'
require 'twitter'

class App

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['Mx1wGw1SqsUxVbazaxousL5Y1']
      config.consumer_secret = ENV['LcZnAHkWYvkX2QQUFYAIxXjq6pzMZdQ0pXaAtY7rE67vPgStYe']
      config.access_token = ENV['1308010067380310018-le1bJPH3b8VyFQxk3qH2QB3HxBgAWq']
      config.access_token_secret = ENV['i2xhlAS5PFSacTP7EFEzcvYagRUV30QEayIBf8XTZvkMB']
    end

    @wait_time = 10 * 60

    @hashtags = '#3Drendering #teamcolor'
  end

  def run
    while true
      begin
      puts "Begin routine at #{DateTime.now}"
      @hashtags.split(' ').each do |hashtag|
        puts "Retweeting #{hashtag}"
        @client.search("#{hashtag} -rt", lang: "en").take(5).each do |object|
          try_retweet(object)
        end
      end

      # Mentions
      @client.mentions_timeline.take(5).each do |mention|
        try_retweet(mention)
      end

      sleep(@wait_time)
      rescue Twitter::Error::TooManyRequests
        puts "I have mad too many requests to twitter. I will sleep for some time"
        sleep(@wait_time * 4)
      end
    end
  end

  def try_retweet(object)
    begin
      case object
        when Twitter::Tweet
          @client.retweet object unless @client.retweets(object.id, options = {}).count > 0
      end
    rescue Twitter::Error::Forbidden
      $stderr.print "Something has failed " + $!
    end
  end
end


app = App.new
app.run
