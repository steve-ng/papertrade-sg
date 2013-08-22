class HomeController < ApplicationController
	skip_before_action :authorize
	before_action :set_user, only: [:index]
  #before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    render :layout => "user"
    #Stock.test 'SK6U.SI'
    #Stock.searchSymbol 'starhub'
    #Stock.historicalData 'CC3.SI','2013-07-21','2013-07-25'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
    	@user = User.new
    end
    
end
