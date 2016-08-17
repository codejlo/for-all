get '/races' do
  p user = User.find(current_user.id)
  p divisions = user.divisions
  p offices = divisions.map { |division| division.offices }.flatten
  p races = offices.select { |office| office.race }.map { |office| office.race }

  erb :'/races/index', locals: {races: races}
end

get '/races/:id' do
  race = Race.find(params[:id])
  if request.xhr?
    p "I'm Ajaxing"
    erb :'/races/show', layout: false, locals: {candidates: race.candidates}
  else
    p "I'm NOT Ajaxing"
    erb :'/races/show', locals: {candidates: race.candidates}
  end
end
