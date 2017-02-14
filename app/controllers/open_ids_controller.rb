class OpenIdsController < ApplicationController

	#dit is de callback die aangeroepen word na login van de gebruiker op de sso server
	def show
		provider = Provider.find params[:provider_id]
		open_id = provider.authenticate(
			provider_open_id_url(provider),
			params[:code],
			stored_nonce
		)
		
		userinfo = open_id.to_access_token.userinfo!
		puts "#{userinfo.email} logged in via sso"
	
		#if we have a user with the same email adress, lets log in
		#TODO: this should work differently, by coupling it to an account or something	
        user = User.where(["email = ?", userinfo.email]).first
		if(user != nil)
        	session[:user_id] = user.id
		end
		
		redirect_to root_url	
	end

	def create
		provider = Provider.find params[:provider_id]
		redirect_to provider.authorization_uri(
			provider_open_id_url(provider),
			new_nonce
		)
	end
end
