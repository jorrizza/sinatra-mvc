# Run tests if the user calls sinatra-mvc test.

if ENV['RACK_ENV'] == 'test' && !defined? RACKUP
  puts '>> Running unit tests using Rack::Test'
  require 'test/unit'
  require 'rack/test'

  # A general test case class for SinatraMVC.
  class SinatraMVC
    class UnitTest < Test::Unit::TestCase
      include Rack::Test::Methods
      
      def app
        ::SinatraMVC
      end
    end
  end

  # Add every test defined in our project to the unit test.
  SinatraMVC.tests.each do |t|
    SinatraMVC::UnitTest.class_exec &t
  end

  # Because test/unit is just a MiniTest shell, we can cheat a bit
  # here to start the tests.
  MiniTest::Unit.new.run(ARGV)
  
  # We don't want to start the server, now do we?
  puts '>> Done testing'
  exit
end
