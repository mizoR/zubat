# frozen_string_literal: true

module Zubat
  class RubyCode
    def initialize(code:)
      @code = code
    end

    def valid?
      RubyVM::InstructionSequence.compile(@code)

      true
    rescue SyntaxError
      false
    end
  end
end
