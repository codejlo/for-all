get '/initiatives' do
  p user = User.find(current_user.id)
  p divisions = user.divisions
  p initiatives = divisions.select { |division| division.initiatives }.map { |division| division.initiatives }.flatten

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
