# encoding: UTF-8

module BadTwitt
  # BAD_WORDS = ["porra", "filho da puta", "vagabunda", "viado", "gordo", "negão"]
  
  CORRECT_WORDS = {"porra"=>"poxa", "filho da puta"=>"filho da mãe", "vagabunda"=>"meretriz", "viado"=>"gay", "gordo"=>"obeso", "negão"=>"afro brasileiro"}

  BAD_WORDS = CORRECT_WORDS.keys
  

  def self.classify id, user, message
    if message =~ /#{BAD_WORDS[3..BAD_WORDS.size].join("|")}/
      PoliticallyIncorrect.new(id,user,message)
    elsif message =~ /#{BAD_WORDS[0..2].join("|")}/
      Profane.new( id, user, message )
    else  
      raise Unclassified
    end
  end
  
  class Unclassified < StandardError
  end  
  
  #TODO CODE HERE
  class Twitt
    @@list_twitt = []
    attr_reader :id, :user, :message, :reply
    def initialize id, user, message
      @id = id
      @user = user
      @message = message
      if ! @@list_twitt.include? id
        @@list_twitt << id
        @reply = true
      else
        @reply = false
      end
    end
    def self.clear
      @@list_twitt.clear
    end
    def self.replied
      @@list_twitt
    end
    def reply?
      reply
    end
  end
  
  class Profane < Twitt
    def reply
      for key,word in CORRECT_WORDS
        if message =~ /#{key}/
          return "@#{user}: Existem crianças na internet. Por favor, não escreva palavrões. Utilize o termo '#{word}'."
        end  
      end  
    end
  end
  
  class PoliticallyIncorrect < Twitt
    def reply
      for key,word in CORRECT_WORDS
        if message =~ /#{key}/
          return "@#{user}: Pessoas podem se ofender com o que você escreve. Utilize o termo '#{word}'."
        end  
      end  
      
    end
  end
end