#json beautifier at http://www.jsoneditoronline.org/
require 'time'
require 'date'
require "open-uri"
require 'rest_client'
require 'json'
require 'csv'
require 'CGI' #for uri encoding

class Stock < ActiveRecord::Base

  include HolidayChecker
  has_many :orders

  def self.get_stock_current_bid_price(symbol)
    previous_close,open,volume,day_range,bid,ask,name,symbol = get_stock_info(symbol)
    return bid
  end

  def self.get_stock_current_ask_price(symbol)
    previous_close,open,volume,day_range,bid,ask,name,symbol = get_stock_info(symbol)
    return ask
  end

  def self.get_stock_info(symbol)

    symbol = symbol+'.SI'

    url = 'http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22'+symbol+'%22)%0A%09%09&format=json&env=http%3A%2F%2Fdatatables.org%2Falltables.env&callback='
    #http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22SK6U.SI%22)%0A%09%09&format=json&env=http%3A%2F%2Fdatatables.org%2Falltables.env&callback=

    result = JSON.parse(RestClient.get (url)).fetch("query").fetch("results").fetch("quote")

    ask = result.fetch("Ask")
    bid = result.fetch("Bid")
    previous_close = result.fetch("PreviousClose")
    open = result.fetch("Open")
    volume = result.fetch("Volume")
    day_range = result.fetch("DaysRange")
    name = result.fetch("Name")
    symbol = result.fetch("symbol")
  	#puts("current price =="+currentPrice)

    return previous_close,open,volume,day_range,bid,ask,name,symbol

  end

  def self.search_symbol(name)
    #http://www.google.com/finance/match?matchtype=matchall&q=M1

    name = CGI::escape(name)

    url = 'http://www.google.com/finance/match?matchtype=matchall&q='+name

    result = RestClient.get(url)

    # parsed_json = JSON.parse(result).fetch('ResultSet').fetch('Result')
    stock_result = Hash.new     

    JSON.parse(result).fetch('matches').each do |item|
      if item['e'] == 'SGX'
        stock_result[item['t']] = item['n']
      end 
    end

    stock_result.each do |key,value| 
      puts key + ' '+ value
    end 

    return stock_result


  end

def self.get_historical_from_yahoo(symbol) 

    symbol = symbol + '.SI'

    current_time = Time.now - (24 * 60 * 60)
    #364 days * 24 hours a day * 60 mins a day * 60 seconds a day
    #one_year_ago = current_time - (364*24*60*60)
    before_date = current_time - (5*364*24*60*60)

    start_date = '&a='+(before_date.month-1).to_s+'&b='+before_date.day.to_s+'&c='+before_date.year.to_s
    end_date = '&d='+(current_time.month-1).to_s+'&e='+current_time.day.to_s+'&f='+current_time.year.to_s

    url = 'http://ichart.yahoo.com/table.csv?s='+symbol+start_date+end_date+'&g=d'

    puts 'url from yahoo = '+url

    historical_price =[]

    csv = CSV.parse(open(url), :headers=>true)
    csv.each do |row|
     unix_timestamp = Time.parse(row["Date"]).to_i * 1000
     individual_price = [unix_timestamp, row["Close"].to_f]
     historical_price.push individual_price
   end
   return historical_price.reverse

 end

 def self.get_historical_from_google(symbol)

  #HolidayChecker.say_hello

  url = 'https://www.google.com/finance/getprices?q='+symbol+'&x=SGX&i=86400&p=1Y'


  historical_price =[]

  csv = CSV.parse(open(url), :headers=>true)

  #finding out where time stamp row starts
  timestamp_row = 0;
  csv.each_with_index do |row, index|
    if row[0][0] == 'a'
      timestamp_row = index
      break
    end
  end 

  #extracting the timestamp and close price from first row
  first_time = csv[timestamp_row][0]
  first_time[0] = ''
  puts first_time.to_s
  time_counter = first_time.to_i

  first_close_price = csv[7][1].to_f 
  individual_price = [time_counter * 1000, first_close_price]
  puts 'individual price'
  puts individual_price
  historical_price.push individual_price 

  #
  csv.drop(timestamp_row).each do |row| 
    time_counter = time_counter + 86400

    #puts 'intitial time counter =='+time_counter.to_s
    until !HolidayChecker.is_singapore_holiday(time_counter)
      time_counter = time_counter + 86400
    end

    until !Time.at(time_counter).to_datetime.saturday?  do
      time_counter = time_counter + 86400
      if Time.at(time_counter).to_datetime.sunday? 
        time_counter = time_counter + 86400
      end
    end

    #puts 'after time counter =='+time_counter.to_s

    individual_price = [time_counter * 1000, row[1].to_f]
    historical_price.push individual_price
  end

  puts 'hehe historical stuff'
  historical_price.each do |row|
   #puts row
  end

  return historical_price
end

def self.get_historical_data(symbol)

  begin 
    return get_historical_from_yahoo(symbol)
  rescue OpenURI::HTTPError

    puts 'gotten from google'

    return get_historical_from_google(symbol)

  end

end

def self.search_symbol_yahoo_depricated(name)

    #name = name.gsub(' ','%20')
    name = CGI::escape(name)

    url = 'http://autoc.finance.yahoo.com/autoc?query='+name+'&callback=YAHOO.Finance.SymbolSuggest.ssCallback'

    result = RestClient.get(url).at(39..-2)

    # parsed_json = JSON.parse(result).fetch('ResultSet').fetch('Result')
    stock_result = Hash.new     

    JSON.parse(result).fetch('ResultSet').fetch('Result').each do |item|
      if(item['exchDisp'] == 'Singapore' && item['type'] == 'S')
        stock_result[item['symbol']] = item['name']
      end 
    end

    

    return stock_result

  end


end
