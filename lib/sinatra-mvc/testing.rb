class SinatraMVC
  class << self
    # TODO: Override get, put, post and delete to track test coverage.
    
    # A test block within SinatraMVC will do nothing.
    # It only stores the block for use when we're actually testing.
    def test(path = nil, &block)
      if test?
        @@tests ||= []
        @@tests << block
      end
    end

    # Returns an array of test blocks if in testing mode.
    def tests
      if test?
        @@tests
      end
    end
  end
end
