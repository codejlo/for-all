get '/users' do
  @users = User.order(created_at: :desc)
  erb :'/users/index'
end

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
    @errors = errors.full.messages
    if request.xhr?
      erb :'/users/new', layout: false, locals: {errors: errors}
    else
      erb :'/users/new'
    end
  end
end

get '/users/:id' do
  @user = User.find(params[:id])
  @votes = @user.votes

  @current_user_divisions = current_user.divisions
  current_user_offices = @current_user_divisions.map { |division| division.offices }.flatten
  @current_user_races = current_user_offices.select { |office| office.race }.map { |office| office.race }

  erb :'/users/show'
end

post '/users/:user_id/follow' do
  user = User.find(params[:user_id])
  if params[:follow] && !current_user.following.include?(user)
    current_user.following << user
  elsif !params[:follow] && current_user.following.include?(user)
    # implement destroy
  end

  redirect '/users'
end
