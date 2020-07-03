# frozen_string_literal: true

module Peddler
  # @!visibility private
  class StructuredList
    def initialize(*keys)
      @keys = keys
    end

    def build(vals)
      Array(vals)
        .flatten
        .each_with_index
        .reduce({}) { |hsh, (v, i)| hsh.merge(compose_key(i + 1) => v) }
    end

    private

    def compose_key(index)
      (@keys.dup << index).join('.')
    end
  end
end
