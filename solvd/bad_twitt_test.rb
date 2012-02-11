# encoding: UTF-8
require "test/unit"
require File.expand_path('../bad_twitt',  __FILE__)

class ProfanityCopTest < Test::Unit::TestCase

  def test_initializer
    twit = BadTwitt::Twitt.new(10, 'foo', "twitter rocks.")
    assert_equal 10, twit.id
    assert_equal 'foo', twit.user
    assert_equal 'twitter rocks.', twit.message
  end

  def test_replied_and_clear
    BadTwitt::Twitt.clear
    BadTwitt::Twitt.new(10, 'foo', "twitter rocks.")
    BadTwitt::Twitt.new(20, 'foo', "twitter rocks.")
    BadTwitt::Twitt.new(30, 'foo', "twitter rocks.")
    assert_equal [10, 20, 30], BadTwitt::Twitt.replied
    BadTwitt::Twitt.clear
    assert_equal [], BadTwitt::Twitt.replied
  end

  def test_reply?
    assert BadTwitt::Twitt.new(10, '', '').reply?
    assert ! BadTwitt::Twitt.new(10, '', '').reply?

    assert BadTwitt::Twitt.new(20, '', '').reply?
    assert ! BadTwitt::Twitt.new(20, '', '').reply?
  end

  def test_bad_words
    assert_equal ["porra", "filho da puta", "vagabunda", "viado", "gordo", "negão"], BadTwitt::BAD_WORDS
  end

  def test_classify_as_profane
    profane = BadTwitt.classify(10, '', 'porra')
    assert profane.is_a?(BadTwitt::Profane)
  end

  def test_classify_as_politically_incorrect
    politically_incorrect = BadTwitt.classify(10, '', 'viado')
    assert politically_incorrect.is_a?(BadTwitt::PoliticallyIncorrect)
  end

  def test_raise_unclassified
    assert_raise BadTwitt::Unclassified do
      BadTwitt.classify(10, '', 'eu amo a Disney')
    end
  end

  def test_reply_profane_term
    twit = BadTwitt.classify(10, 'foo', "isso é uma porra!")
    assert_equal twit.reply, "@foo: Existem crianças na internet. Por favor, não escreva palavrões. Utilize o termo 'poxa'."

    twit = BadTwitt.classify(10, 'foo', "você é um filho da puta!")
    assert_equal twit.reply, "@foo: Existem crianças na internet. Por favor, não escreva palavrões. Utilize o termo 'filho da mãe'."

    twit = BadTwitt.classify(10, 'foo', "você é uma vagabunda!")
    assert_equal twit.reply, "@foo: Existem crianças na internet. Por favor, não escreva palavrões. Utilize o termo 'meretriz'."
  end

  def test_reply_politically_incorrect_term
    twit = BadTwitt.classify(10, 'foo', "você é um viado!")
    assert_equal twit.reply, "@foo: Pessoas podem se ofender com o que você escreve. Utilize o termo 'gay'."

    twit = BadTwitt.classify(10, 'foo', "você é um gordo!")
    assert_equal twit.reply, "@foo: Pessoas podem se ofender com o que você escreve. Utilize o termo 'obeso'."

    twit = BadTwitt.classify(10, 'foo', "você é um negão!")
    assert_equal twit.reply, "@foo: Pessoas podem se ofender com o que você escreve. Utilize o termo 'afro brasileiro'."
  end

end