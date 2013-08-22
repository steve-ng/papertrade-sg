module HolidayChecker
  extend ActiveSupport::Concern

  #http://www.mom.gov.sg/employment-practices/leave-and-holidays/Pages/public-holidays-2012.aspx
  #New Year Day, 1 Jan 2012 (but is sunday) so 2 Jan 2012
  #CNY, 23/24 Jan 2012
  #Good friday, 6 APril 2012
  #Labor day, 1 May 2012
  #Vesak Day, 5 May 2012
  #National Day, 9 Aug 2012
  #Hari Raya Puasa, 19 Aug 2012
  #Hari Raya Haji, 26 oct 2012
  #Deepavali, 13 Nov 2012
  #Christmas 25 Dec 2012

  #http://www.mom.gov.sg/employment-practices/leave-and-holidays/Pages/public-holidays-2013.aspx
  #New Year Day, 1 Jan 2013
  #CNY 10/11 Feb, but 10 = sunday so, 11/12 Feb 2013
  #GOod friday, 29 March 2013
  #Labor Day, 1 May 2013
  #VesakDay, 24 May 2013
  #Hari Raya Puasa, 8 Aug 2013
  #National day, 9 Aug 2013
  #Hari Raya Haji, 15 Oct 2013
  #Depavali, 2 Nov 2013
  #CHristmas 25 Dec 2013 

  def self.is_singapore_holiday(timestamp)



  end


 end 