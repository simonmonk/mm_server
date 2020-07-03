# frozen_string_literal: true

require 'peddler/xml_parser'

module Peddler
  # @!visibility private
  class XMLResponseParser < XMLParser
    MATCHER = /^Message$|Report|Result/.freeze
    private_constant :MATCHER

    def next_token
      parse.fetch('NextToken', false)
    end

    private

    def find_data
      payload = xml.values.first
      found = payload.find { |k, _| k.match(MATCHER) }

      found&.last
    end
  end
end
