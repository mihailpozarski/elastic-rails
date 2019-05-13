module Elastic::Nodes
  class Match < Base
    include Concerns::Boostable
    include Concerns::FieldQuery

    MATCH_MODES = [:boolean, :phrase, :phrase_prefix]

    attr_accessor :query
    attr_reader :mode

    def query=(_query)
      raise ArgumentError, 'query must be a string' unless _query.is_a? String
      @query = _query
    end

    def mode=(_value)
      _value = _value.try(:to_sym)
      raise ArgumentError, 'invalid match mode' if !_value.nil? && !MATCH_MODES.include?(_value)
      @mode = _value
    end

    def clone
      prepare_clone(super)
    end

    def simplify
      prepare_clone(super)
    end

    def render(_options = {})
      hash = { 'query' => @query }

      match_mode = @mode.nil? || @mode == :boolean ? 'match' : "match_#{@mode}"

      { match_mode => { render_field(_options) => render_boost(hash) } }
    end

    private

    def prepare_clone(_clone)
      _clone.field = @field
      _clone.query = @query
      _clone.mode = @mode
      _clone
    end
  end
end
