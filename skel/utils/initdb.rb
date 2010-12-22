# Initializes the database if asked to.

# Are you sure?
print "\nWarning, this will DESTROY EVERYTHING YOU HAVE!\nAnd probably more...\n\nAre you sure? (y/N)"
STDOUT.flush
answer = STDIN.gets
exit unless answer == "y\n"

# Rebuild the database structure.
DataMapper.auto_migrate!

# Add custom things to do after an init here
