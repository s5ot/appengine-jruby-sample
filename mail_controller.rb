get '/mail_index' do
  @user = AppEngine::Users.current_user
  
  unless @user
    redirect AppEngine::Users.create_login_url(request.url)
  end

  erb :mail_index
end 
  
post '/send_mail' do
  user = AppEngine::Users.current_user
  nickname = user.nickname
  mailaddr = user.email
  AppEngine::Mail.send(mailaddr, "#{nickname}<#{mailaddr}>", params[:title], params[:body])

  flash[:notice] = "Successfully sended mail."
  redirect '/mail_index'
end
