get '/' do
  if logged_in?
    redirect '/representatives'
  else
    redirect '/sessions/new'
  end

end
