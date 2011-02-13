class SinatraMVC
  class << self
    @@tests = []
    @@test_paths = []

    # Override get, put, post and delete to track test coverage.
    @@controller_calls = {}
    [:get, :put, :post, :delete].each do |method|
      @@controller_calls[method] = []
    end

    # Wrapper for tracking Sinatra::Base#get calls.
    def get(path, opts={}, &block)
      @@controller_calls[:get] << path
      
      super path, opts, &block
    end
    
    # Wrapper for tracking Sinatra::Base#put calls.
    def put(path, opts={}, &block)
      @@controller_calls[:put] << path
      
      super path, opts, &block
    end
    
    # Wrapper for tracking Sinatra::Base#post calls.
    def post(path, opts={}, &block)
      @@controller_calls[:post] << path
      
      super path, opts, &block
    end
    
    # Wrapper for tracking Sinatra::Base#delete calls.
    def delete(path, opts={}, &block)
      @@controller_calls[:delete] << path
      
      super path, opts, &block
    end
    
    # A test block within SinatraMVC will do nothing.
    # It only stores the block for use when we're actually testing.
    def test(path = nil, &block)
      if test?
        @@tests << block
        @@test_paths << path
      end
    end

    # Returns an array of test blocks if in testing mode.
    def tests
      if test?
        @@tests
      end
    end

    # Returns a test coverage report if in testing mode.
    # TODO: track individual tests for HTTP methods in Rack::Test.
    def test_coverage
      if test?
        coverage = {}

        @@controller_calls.each do |method, calls|
          tests_done = calls.map do |call|
            @@test_paths.include?(call)
          end
          coverage[method] = Hash[*calls.zip(tests_done).flatten]
        end

        coverage
      end
    end
  end
end
