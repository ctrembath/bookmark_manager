get '/users/reset_password' do
  erb :"users/reset_password"
end

post '/users/forgot_password' do
  user = User.first(email: params[:email])
    if user
      token = password_token
      user.update(password_token: token, password_token_timestamp: password_token_timestamp)
      user.send_message(user.email, token)
      flash[:notice] = "Reset instructions sent to #{email}"
      redirect '/'
    else
      flash[:notice] = "Please check your email address"
      redirect '/'
  end
end

get'/users/reset_password/:token' do
  @token = params[:token]
  user = User.first(password_token: @token)    
  erb :'users/new_password'
end

post "/users/new_password" do
  user = User.first(password_token: params[:password_token] )
  user.update(password: params[:password], password_confirmation: params[:password_confirmation], password_token: nil)
  'password updated'    
end
