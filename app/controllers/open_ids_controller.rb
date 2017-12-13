class OpenIdsController < ApplicationController

	#dit is de callback die aangeroepen word na login van de gebruiker op de sso server
	def show
		provider = Provider.find params[:provider_id]
		open_id = provider.authenticate(
			provider_open_id_url(provider),
			params[:code],
			stored_nonce
		)

		token = open_id.to_access_token
		userinfo = token.userinfo!
		#logger.info "userinfo: #{userinfo.inspect}"

		#match by email 
		#if we have a user with the same email adress, lets log in
		#TODO (optional?): match by sub, if we can't find by sub, try to match by email, then assign sub... 
		# not really necessary though, because email is the main login, 
		# and if the gluu database needs to be reset, this can be used regardless..

		user = User.where(["email = ?", userinfo.email]).first
		if(user != nil)
			#actually perform the log in of the matched user
			session[:user_id] = user.id
			redirect_to root_url, flash: { success: "Signed in!" }
			#logger.info("matched")
		else
			#generate random password
			pw = (0...8).map { (65 + rand(26)).chr }.join

			#register the user as a new user and then log in the user
			#username is invalid
			params = {
				:email => userinfo.email,
				:first_name => userinfo.given_name,
				:last_name => userinfo.family_name,
				:username => userinfo.email,
				:password => pw,
				:password_confirmation => pw
			}
			user = User.new params
			#logger.info("created new user: #{user}")
			user.workflow_state = :verified #bypass the workflow system

			if user.save(:validate => false) #skipping validation because we are creating the user programatically
				#logger.info("saved new user")
				UserMailer.delay.welcome(user.id)
				session[:user_id] = user.id
				redirect_to root_url			
			else
				#logger.info user.errors.full_messages
				redirect_to root_url, flash: { error: "Save new user failed..."}
			end
		end

	end

	def create
		provider = Provider.find params[:provider_id]
		redirect_to provider.authorization_uri(
			provider_open_id_url(provider),
			new_nonce
		)
	end
end
