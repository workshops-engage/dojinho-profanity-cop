# encoding: UTF-8
require 'twitter'

module BadTwitt

  class Unclassified < StandardError; end

  PROFANITIES = {
    "porra" => "poxa",
    "filho da puta" => "filho da mãe",
    "vagabunda" => "meretriz"
  }

  POLITICALLY_INCORRECT = {
    "viado" => "gay",
    "gordo" => "obeso",
    "negão" => "afro brasileiro"
  }

  BAD_WORDS = PROFANITIES.keys + POLITICALLY_INCORRECT.keys

  def self.classify id, user, message
    return Profane.new(id, user, message) if message =~ /#{PROFANITIES.keys.join("|")}/
    return PoliticallyIncorrect.new(id, user, message) if message =~ /#{POLITICALLY_INCORRECT.keys.join("|")}/
    raise Unclassified
  end

  class Twitt

    @@replied = []
    attr_reader :id, :user, :message

    def self.replied
      @@replied
    end

    def self.clear
      @@replied = []
    end

    def initialize id, user, message
      @id = id
      @user = user
      @message = message
      @should_reply = ! @@replied.include?(id)
      @@replied << id
    end

    def reply?
      @should_reply
    end

    def word_to_say list
      list.detect{|bad,ok| return ok if message.include?(bad) }
    end

  end

  class Profane < Twitt

    def reply
      "@#{user}: Existem crianças na internet. Por favor, não escreva palavrões. Utilize o termo '#{word_to_say(PROFANITIES)}'."
    end

  end

  class PoliticallyIncorrect < Twitt

    def reply
      "@#{user}: Pessoas podem se ofender com o que você escreve. Utilize o termo '#{word_to_say(POLITICALLY_INCORRECT)}'."
    end
  end

end