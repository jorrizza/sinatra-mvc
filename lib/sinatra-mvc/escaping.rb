# Like rails, make h() escape HTML characters.

class SinatraMVC
  helpers do
    def h(s)
      Rack::Utils.escape_html s
    end
  end
end
