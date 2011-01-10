# In classic mode, the helpers are available in request
# context. Now we have to re-supply these because some people
# use them a lot. Using the Delegator is a bit too much for
# this use case.

class SinatraMVC
  helpers do
    def development?
      settings.environment == 'development'
    end
    def test?
      settings.environment == 'test'
    end
    def production?
      settings.environment == 'production'
    end
  end
end
