get '/initiatives' do
  user = User.find(current_user.id)
  divisions = user.divisions
  initiatives = divisions.select { |division| division.initiatives }.map { |division| division.initiatives }.flatten

  erb :'/initiatives/index', locals: {initiatives: initiatives}
end

get '/initiatives/:id' do
  initiative = Initiative.find(params[:id])
  if request.xhr?
    p "I'm Ajaxing"
    erb :'/initiatives/show', layout: false, locals: {initiative: initiative}
  else
    p "I'm NOT Ajaxing"
    erb :'/initiatives/show', locals: {initiative: initiative}
  end
end

post '/initiatives/:initiative_id/votes' do
  initiative = Initiative.find(params[:initiative_id])
  vote = Vote.find_by(user_id: current_user.id, initiative_id: initiative.id)

  if vote
    vote.destroy
  end

  new_vote = Vote.create(initiative_selection: params[:initiative_selection])
  current_user.votes << new_vote
  initiative.votes << new_vote

  if request.xhr?
    erb  :'/initiatives/show', layout: false, locals: {initiative: initiative }
  else
    erb  :'/initiatives/show', locals: {initiative: initiative }
  end
end
