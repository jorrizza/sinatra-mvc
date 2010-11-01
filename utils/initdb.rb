# Initializes the database if asked to.
require 'dm-migrations'

# Are you sure?
print "\nWarning, this will DESTROY EVERYTHING YOU HAVE!\nAnd probably more...\n\nAre you sure? (y/N)"
STDOUT.flush
answer = STDIN.gets
exit unless answer == "y\n"

# Rebuild the database structure.
DataMapper.auto_migrate!

# Add the root category.
root_cat = Category.new
root_cat.name = 'Home'
root_cat.margin = 1.0
raise RuntimeError unless root_cat.save

# Add the "uncategorized" category.
# This will be our second root, so by default call #first_root.
uncat_cat = Category.new
uncat_cat.name = 'Uncategorized'
uncat_cat.margin = 1.0
raise RuntimeError unless uncat_cat.save
