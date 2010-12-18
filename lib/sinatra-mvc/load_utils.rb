# Loads the proper utility from the utils directory
# when that utility is called as a command line option.

if ARGV[0] && !defined? RACKUP
  util = File.join(PROJECT, 'utils', "#{ARGV[0]}.rb")
  if File.exists? util
    printf "Running util %s.\n", ARGV[0]
    require util
    exit
  else
    printf ">> Util %s does not exist. Continue as normal.\n", ARGV[0]
  end
end
