get '/representatives' do
  p user = User.find(current_user.id)
  p divisions = user.divisions
  p offices = divisions.map { |division| division.offices }.flatten
  p politicians = offices.map { |office| office.politicians }
  erb :'/representatives/index', locals: {representatives: politicians}
end

get '/representatives/:id' do
  p politician = Politician.find(params[:id])
  if request.xhr?
    erb :'/representatives/show', layout: false, locals: {representative: politician}
  else
    erb :'/representatives/show', locals: {representative: politician}
  end
end
