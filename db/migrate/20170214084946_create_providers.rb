class CreateProviders < ActiveRecord::Migration
	def change
		create_table :providers do |t|
			t.string :issuer, :jwks_uri, :name, :identifier, :secret, :scopes_supported, :host, :scheme
			t.string :authorization_endpoint, :token_endpoint, :userinfo_endpoint
			t.boolean :dynamic, default: false
			t.datetime :expires_at
			t.timestamps
		end
	end
end
