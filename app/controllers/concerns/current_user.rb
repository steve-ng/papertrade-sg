module CurrentUser extend ActiveSupport::Concern

  private

    def set_user
    	#@user = User.find_by(id: session[:user_id])
    	puts 'came here! hehe';
    	@user ||= User.find(session[:user_id]) if session[:user_id]
    end

end
