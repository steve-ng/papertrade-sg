class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id

    redirect_to stocks_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
  
  # def create
  #   puts("came here with user ==")
  #   puts(params[:name])
  #   puts(params[:password])

  #   user = User.find_by(name: params[:name])
  #   if user and user.authenticate(params[:password])
  #     session[:user_id] = user.id
  #     session[:user_name] = user.name
  # 		#redirect_to login_url
  # 		redirect_to orders_path
  # 	else
  # 		redirect_to login_url, alert: "Invalid user/password combination"
  # 	end
  # end

  # def destroy
  # 	session[:user_id] = nil
  #   puts("came here")
  # 	redirect_to root_url, notice: "Logged out"
  # end
end
