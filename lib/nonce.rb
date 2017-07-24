module Nonce
	class Exception < StandardError; end
	class SessionBindingRequired < Exception; end

	def new_nonce
		session[:nonce] = SecureRandom.hex(16)
	end

	def stored_nonce
		session.delete(:nonce) or raise SessionBindingRequired.new('Invalid Session')
	end
end
