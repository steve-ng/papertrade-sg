class OrdersController < ApplicationController
  include CurrentUser
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:new, :create, :index, :buy, :sell, :delete_all]
  # GET /orders
  # GET /orders.json
  def index
    # @user = User.find_by(id: session[:user_id])
    
    # stock owned table codes 
    @stock_owned = Order.where("user_id =? AND sell_price is NULL",@user.id)


    ## getting average buy price ########################
    total_spending = Order.where('user_id=?',@user.id).group('stock_id').sum('quantity * buy_price') #{4 => 5775, 5=>6775}
    @total_quantity = Order.where('sell_price is NULL and user_id=?',@user.id).group('stock_id').sum('quantity') #{4=> 1225, #6765}

    puts('pringint total quantity')
    @total_quantity.each do |hehe|
      puts hehe
    end

    @average_buy_price = Hash.new
    total_spending.each do |key, value| 
      puts 'key ==' + key.to_s
      @average_buy_price.merge!(key => (total_spending[key] / @total_quantity[key]))
    end 

    puts 'printing average buy price'
    @average_buy_price.each do |try|
      puts try
    end

    ## end of getting the average buy price into the hash ############################

    ## getting all the stock name and symbol ######################
    @owned_stock = Array.new 
    @average_buy_price.each do |key, value|
      @owned_stock.push Stock.find_by id: key
    end 

    ## end of getting stock and symbol 

    puts 'printing out all the relevant counter name and symbol '
    @owned_stock.each do |hehe|
      puts hehe.counter_name + ' '+ hehe.symbol
    end

    ## storing the bid and ask price for each symbol  ################
    @current_bid_price_array = Array.new;
    @current_ask_price_array = Array.new;

    @owned_stock.each do |stock|
      stock_current_bid_price = Stock.get_stock_current_bid_price(stock.symbol)
      @current_bid_price_array.push stock_current_bid_price

      stock_current_ask_price = Stock.get_stock_current_ask_price(stock.symbol)
      @current_ask_price_array.push stock_current_ask_price

    end
    ## end of getting the bid and ask price for each symbol ##################


    

    #consolidate all the buy order 

    # tranasction table codes
    @transaction = Order.where("user_id =?",@user.id)

    #Stock.get_stock_info(@stock_ownedd)
    # @buy_order = Order.where("user_id =? AND buy_price < 0",@user.id)
    # @sell_order = Order.where("user_id =? AND sell_price > 0",@user.id)
    # @amount_left = 100000 + Order.total_cost(@user.id)
    #@orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  def delete_all
    puts "came inside delete_all" 
    puts @user.name.to_s + ' <--username'

    Order.where("user_id=?",@user.id).delete_all

    redirect_to orders_path
  end

  # GET /orders/new
  def new


    @order = Order.new

    puts 'came inside orders/new!!!'
    puts 'symbol= '+ params[:stock_symbol].to_s 
    puts 'price=' + params[:stock_price].to_s 
    puts 'quantity=' + params[:stock_quantity].to_s 
    puts 'date ='+ params[:stock_date].to_s
    puts 'transaction type='+ params[:transaction_type].to_s 

    ## checking if such stocks exist in the first place anot 
    stock = Stock.find_by symbol: params[:stock_symbol]
    if stock.nil?
      redirect_to orders_path, notice: 'no such stock symbol!'
    end 
    
    ## modifying the date based on params passed in
    month,day,year = params[:stock_date].split("/")

    stock_sale_date = DateTime.new(year.to_i,month.to_i,day.to_i)
    puts 'the date is'
    puts stock_sale_date

    ## saving the information 
    @order.user_id = @user.id
    @order.stock_id = stock.id
    @order.created_at = stock_sale_date
    @order.quantity = params[:stock_quantity].to_i
    if params[:transaction_type].to_s == 'buy'
      @order.buy_price = params[:stock_price]
    else
      @order.sell_price = params[:stock_price]
    end


    ## end of saving the order
    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_path, notice: 'Successfully purchased the stocks' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end

  end

  # GET /orders/1/edit
  def edit
  end

  def buy
    puts("came inside buy")
    # get the stock id
    puts(params[:stock_symbol])
    puts(params[:buy_stock_quantity])
    puts(params[:stock_price])
    # check if such id exist in system
    stock = Stock.find_by symbol: params[:stock_symbol]
    if stock.nil?
      # if not add it into the stock table
      stock = Stock.new(counter_name: params[:stock_name], symbol: params[:stock_symbol])
      stock.save
    end 

    # create the transaction
    @order = @user.orders.build
    @order.buy_price = params[:stock_price]
    @order.quantity = params[:buy_stock_quantity]
    @order.stock_id = stock.id
    #@order.buy_date = DateTime.now
    
    @user.facebook.put_connections("me", "papertrade_sg:buy", stock: request.referer)

    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_path, notice: 'Successfully purchased the stocks' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
    # redirect to portfolio page
  end

  def sell
    # puts("came inside sell! with ID ==")
    # puts(params[:id])
    # Order.sell_item(params[:id])
    # redirect_to orders_path 

    stock = Stock.find_by symbol: params[:stock_symbol]
    if stock.nil?
      # if not add it into the stock table
      stock = Stock.new(counter_name: params[:stock_name], symbol: params[:stock_symbol])
      stock.save
    end 

    # create the transaction
    @order = @user.orders.build
    @order.sell_price = params[:stock_price]
    @order.quantity = params[:sell_stock_quantity]
    @order.stock_id = stock.id
    #@order.sell_date = DateTime.now

    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_path, notice: 'Successfully sold the stocks' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end

  end 

  # POST /orders
  # POST /orders.json
  def create

    stock = Stock.find(params[:stock_id])
    @order = @user.orders.build(stock: stock)
    @order.price = stock.price * -1
    @order.quantity = params[:quantity]

    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_path, notice: 'Order was successfully created.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:price, :quantity, :stock, :user_id)
    end
  end
