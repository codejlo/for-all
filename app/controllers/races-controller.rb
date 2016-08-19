get '/races' do
  user = User.find(current_user.id)
  divisions = user.divisions
  offices = divisions.map { |division| division.offices }.flatten
  races = offices.select { |office| office.race }.map { |office| office.race }

  erb :'/races/index', locals: {races: races}
end

get '/races/:id' do
  race = Race.find(params[:id])
  if request.xhr?
    erb :'/races/show', layout: false, locals: {candidates: race.candidates}
  else
    erb :'/races/show', locals: {candidates: race.candidates}
  end
end

post '/races/:race_id/votes' do
  p "I'M IN THE ROUTE********"*10
  race = Race.find(params[:race_id])
  candidate = Candidate.find(params[:candidate_id])
  vote = Vote.find_by(user_id: current_user.id, race_id: race.id)

  if vote
    vote.destroy
  end

  new_vote = Vote.create()
  current_user.votes << new_vote
  race.votes << new_vote
  candidate.votes << new_vote

  if request.xhr?
    erb :'/races/show', layout: false, locals: {candidates: race.candidates}
  else
    erb :'/races/show', locals: {candidates: race.candidates }
  end
end
