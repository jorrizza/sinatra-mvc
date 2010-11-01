# Loads the proper utility from the utils directory
# when that utility is called as a command line option.

if ARGV[0]
  if File.exists? "utils/#{ARGV[0]}.rb"
    printf "Running util %s.\n", ARGV[0]
    require "utils/#{ARGV[0]}"
    exit
  else
    printf ">> Util %s does not exist. Continue as normal.\n", ARGV[0]
  end
end
