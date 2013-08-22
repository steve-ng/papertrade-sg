class AddOauthInfoToUser < ActiveRecord::Migration
  def change
  	add_column :users, :image_url, :string 
  	add_column :users, :uid, :string 
  	add_column :users, :auth_token, :string
  	add_column :users, :oauth_token, :string
  	add_column :users, :oauth_expires_at, :datetime 
  	add_column :users, :provider, :string 
  end
end

