class ChangeLabCriteria < ActiveRecord::Migration
	def up
		change_column :lab_criteria, :principle1, :text
		change_column :lab_criteria, :principle2, :text
		change_column :lab_criteria, :principle3, :text
		change_column :lab_criteria, :principle4, :text
		change_column :lab_criteria, :principle5, :text
		change_column :lab_criteria, :principle6, :text
		change_column :lab_criteria, :principle7, :text
		change_column :lab_criteria, :service1, :text
		change_column :lab_criteria, :service2, :text
		change_column :lab_criteria, :service3, :text
		change_column :lab_criteria, :service4, :text
		change_column :lab_criteria, :service5, :text
	end
	def down
		# This might cause trouble if you have strings longer
		# than 255 characters.
		change_column :your_table, :your_column, :string
		change_column :lab_criteria, :principle1, :string
		change_column :lab_criteria, :principle2, :string
		change_column :lab_criteria, :principle3, :string
		change_column :lab_criteria, :principle4, :string
		change_column :lab_criteria, :principle5, :string
		change_column :lab_criteria, :principle6, :string
		change_column :lab_criteria, :principle7, :string
		change_column :lab_criteria, :service1, :string
		change_column :lab_criteria, :service2, :string
		change_column :lab_criteria, :service3, :string
		change_column :lab_criteria, :service4, :string
		change_column :lab_criteria, :service5, :string
	end	
end
