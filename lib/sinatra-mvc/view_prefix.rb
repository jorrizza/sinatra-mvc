# Set the view prefix right if the first part of the URL exists as a subdir
# of our main view directory.
# This construction enables us to recreate some liberty we had in classic
# mode, in which set() could be called in the request scope.

class SinatraMVC
  before do |obj|
    obj.class.class_exec request do |request|
      first_dir = request.env['REQUEST_URI'].split('/')[1]

      if first_dir
        if File.directory? File.join(settings.views_root, first_dir)
          set :views, File.join(settings.views_root, first_dir)
        else
          set :views, settings.views_root
        end
      else
        set :views, settings.views_root
      end
    end
  end
end
