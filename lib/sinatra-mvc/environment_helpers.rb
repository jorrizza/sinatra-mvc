class SinatraMVC
  # In classic mode, the helpers are available in request
  # context. Now we have to re-supply these because some people
  # use them a lot. Using the Delegator is a bit too much for
  # this use case.
  helpers do
    # Is my application running in development mode?
    # Uses Rack's environment.
    def development?
      settings.environment == 'development'
    end
    # Is my application running in test mode?
    # Uses Rack's environment.
    def test?
      settings.environment == 'test'
    end
    # Is my application running in production mode?
    # Uses Rack's environment.
    def production?
      settings.environment == 'production'
    end
  end
end
