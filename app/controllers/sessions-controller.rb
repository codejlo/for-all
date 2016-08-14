get '/sessions/new' do
  erb :'/sessions/new'
end

post '/sessions' do
  user = User.find(email: params[:email])
  if user.authenticate?(params[:password])
    session[:id] = user.id
    redirect '/'
  else
    errors = errors.full.messages
    erb :'/session/new', layout: false, locals: {errors: errors}
  end
end

delete '/sessions/:user_id' do
  session[:id] = nil
  redirect '/'
end
