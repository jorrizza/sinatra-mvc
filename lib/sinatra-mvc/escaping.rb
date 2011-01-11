class SinatraMVC
  helpers do
    # Like rails, make h() escape HTML characters.
    def h(s)
      Rack::Utils.escape_html s
    end
  end
end
