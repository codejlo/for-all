get '/representatives' do
  p user = User.find(current_user.id) # already the user, duh
  p divisions = user.divisions
  p offices = divisions.map { |division| division.offices }.flatten
  p politicians = offices.map { |office| office.politicians }
  erb :'/representatives/index', locals: {representatives: politicians}
end

get '/representatives/:id' do
  politician = Politician.find(params[:id])
  if request.xhr?
    p "I'm Ajaxing"
    erb :'/representatives/show', layout: false, locals: {representative: politician}
  else
    p "I'm NOT Ajaxing"
    erb :'/representatives/show', locals: {representative: politician}
  end
end
