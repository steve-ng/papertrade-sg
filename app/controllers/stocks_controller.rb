class StocksController < ApplicationController
  include CurrentUser
  before_action :set_user
  before_action :set_stock, only: [:show, :edit, :update, :destroy]
  before_action :new_order, only: [:index]
  # GET /stocks
  # GET /stocks.json
  def index
    #auth = User.from_omniauth(env["omniauth.auth"])
    puts 'print hash';
    puts request.env['omniauth.auth'];
    #Stock.get_historical_data2 "CC3.SI"
    #@stocks = Stock.all
    #puts 'came inside index controller'
    #Stock.search_symbol('starhub')
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show

  end

  def search
    puts(params[:stock_name])

    @search_result = Stock.search_symbol(params[:stock_name])
    #Stock.test 'SK6U.SI'
    #Stock.searchSymbol 'starhub'
    #Stock.historicalData 'CC3.SI','2013-07-21','2013-07-25'

    if @search_result.size == 1 

      @previous_close, @open, @volume, @day_range, @bid, @ask, @name, @symbol= Stock.get_stock_info @search_result.keys[0]

      @historical_price = Stock.get_historical_data @search_result.keys[0]
      gon.historical_price = @historical_price
      gon.stock_name = @name

      @total_quantity = Order.get_total_quantity(@user.id,@symbol)
      gon.total_quantity = @total_quantity;

      #redirect_to :controller => 'stocks',:action=> "show",:id=>1
    else

      render '/stocks/index'

    end 
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: 'Stock was successfully created.' }
        format.json { render action: 'show', status: :created, location: @stock }
      else
        format.html { render action: 'new' }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    def new_order
      @order = Order.new 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:counter_name, :price)
    end
	
  end
