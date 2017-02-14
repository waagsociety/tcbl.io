class CreateOpenIds < ActiveRecord::Migration
	def change
		create_table :open_ids do |t|
			t.belongs_to :provider
			t.string :identifier
			t.string :access_token, limit: 1024
			t.string :id_token, limit: 2048
			t.timestamps
		end
	end
end
