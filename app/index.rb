get '/flash' do
  redirect '/', :error => ['Damn, something failed.', 'Gosh, something else failed as well.']
end

get '/' do
  erubis :index
end
