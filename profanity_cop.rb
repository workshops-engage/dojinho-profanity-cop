require 'twitter'
require File.expand_path('../bad_twitt',  __FILE__)

Twitter.configure do |config|
  config.consumer_key = "T4QjunBI3OKVCsWbaQydAA"
  config.consumer_secret = "0ctz6okr69zI4QMz5AuDU6voSwqIWhJGdrd91dX4HXw"
  config.oauth_token = "488533814-mZ1oQg1FaiokW2hzeKmMDTizlBqSFTszRgxx4CTW"
  config.oauth_token_secret = "ScCXxAkCOEl9IqUOxoQfeu7KyvHMbkft7KRhhapqw"
end

loop do
  puts "Buscando..."
  Twitter.search(BadTwitt::BAD_WORDS, :result_type => "recent").map do |status|
    begin
      twitt = BadTwitt.classify(status.id, status.from_user, status.text)
      puts "-> Respondendo para #{status.id}-#{status.from_user}-#{status.text}"
      Twitter.update(twitt.reply) if twitt.reply?
    rescue BadTwitt::Unclassified => e
    rescue Twitter::Error::Forbidden => e
    end
  end
  puts "FIM"
  sleep 10
end