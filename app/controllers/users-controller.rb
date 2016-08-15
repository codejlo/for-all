get '/users/new' do
  erb :'/users/new'
end

post '/users' do
  user = User.new(params[:user])
  if user.save
    user.populate_google_reps
    session[:id] = user.id
    redirect '/'
  else
    errors = errors.full.messages
    if request.xhr?
      erb :'/users/new', layout: false, locals: {errors: errors}
    else
      erb :'/users/new'
    end
  end
end

