class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  #validates_presence_of :password, :on => :create 
  #has_secure_password

  has_many :orders

  #attr_accessor = a native ruby method which defines a getter and setter method for instance class
  #attr_accessor :password_confirmation 

  #http://stackoverflow.com/questions/12444706/confused-about-attr-accessor-and-attr-accessible-in-rails
  #attr_accessible :user_name, :password
  #attr_protected :password

  #validates_confirmation_of :password

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  # private

  # def user_params
  #   params.require(:user).permit(:name, :password, :password_confirmation)
  # end


end
