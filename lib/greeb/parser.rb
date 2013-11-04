# encoding: utf-8

# It is often necessary to find different entities in a natural language
# text. These entities are URLs, e-mail addresses, names, etc. This module
# includes several helpers that could help to solve these problems.
#
module Greeb::Parser
  extend self

  # An URL pattern. Not so precise, but IDN-compatible.
  URL = %r{\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\p{L}\w\d]+\)|([^.\s]|/)))}i

  # A horrible e-mail pattern.
  EMAIL = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i

  # Another horrible pattern. Now for abbreviations.
  ABBREV = /\b((-{0,1}\p{L}\.)*|(-{0,1}\p{L}\. )*)-{0,1}\p{L}\./i

  # This pattern matches anything that looks like HTML. Or not.
  HTML = /<(.*?)>/i

  # Recognize URLs in the input text. Actually, URL is obsolete standard
  # and this code should be rewritten to use the URI concept.
  #
  # @param text [String] input text.
  #
  # @return [Array<Greeb::Entity>] found URLs.
  #
  def urls(text)
    scan(text, URL, :url)
  end

  # Recognize e-mail addresses in the input text.
  #
  # @param text [String] input text.
  #
  # @return [Array<Greeb::Entity>] found e-mail addresses.
  #
  def emails(text)
    scan(text, EMAIL, :email)
  end

  # Recognize abbreviations in the input text.
  #
  # @param text [String] input text.
  #
  # @return [Array<Greeb::Entity>] found abbreviations.
  #
  def abbrevs(text)
    scan(text, ABBREV, :abbrev)
  end

  # Recognize HTML-alike entities in the input text.
  #
  # @param text [String] input text.
  #
  # @return [Array<Greeb::Entity>] found HTML entities.
  #
  def html(text)
    scan(text, HTML, :html)
  end

  private
  # Implementation of regexp-based {Greeb::Entity} scanner.
  #
  # @param text [String] input text.
  # @param regexp [Regexp] regular expression to be used.
  # @param type [Symbol] type field for the new {Greeb::Entity} instances.
  # @param offset [Fixnum] offset of the next match.
  #
  # @return [Array<Greeb::Entity>] found entities.
  #
  def scan(text, regexp, type, offset = 0)
    Array.new.tap do |matches|
      while text and md = text.match(regexp)
        start, stop = md.offset(0)
        matches << Greeb::Entity.new(offset + start, offset + stop, type)
        text, offset = text[stop..-1], offset + stop
      end
    end
  end
end
