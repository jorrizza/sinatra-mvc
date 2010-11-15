get '/' do
  after_post_message :info, "APM Works Correctly!"
  erubis :index
end
