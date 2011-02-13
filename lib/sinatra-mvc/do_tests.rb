# Run tests if the user calls sinatra-mvc test.

if ENV['RACK_ENV'] == 'test' && !defined? RACKUP
  puts '>> Running unit tests using Rack::Test'
  require 'test/unit'
  require 'rack/test'

  class SinatraMVC
    # A general test case class for SinatraMVC.
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

  # Print out the test coverage.
  verbose = ARGV.include? '--verbose'
  number_of_calls = 0
  number_of_tests = 0
  puts "\n>> Verbose test coverage:" if verbose
  SinatraMVC.test_coverage.each do |method, calls|
    puts "  #{method.to_s.upcase}" if verbose && calls.count > 0
    calls.keys.sort.each do |call|
      test_written = calls[call]
      number_of_calls += 1
      number_of_tests += 1 if test_written

      puts "    #{call}: #{test_written ? 'Yes' : 'No'}" if verbose
    end
  end
  puts ">> Test coverage: #{number_of_tests}/#{number_of_calls}"
  
  # We don't want to start the server, now do we?
  puts '>> Done testing'
  exit
end
