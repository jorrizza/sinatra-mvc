# Like rails, make h() escape HTML characters.

helpers do
  def h(s)
    Rack::Utils.escape_html s
  end
end
