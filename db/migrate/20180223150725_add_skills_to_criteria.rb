class AddSkillsToCriteria < ActiveRecord::Migration
  def change
      add_column :lab_criteria, :skill1, :text
      add_column :lab_criteria, :skill2, :text
      add_column :lab_criteria, :skill3, :text
      add_column :lab_criteria, :skill4, :text
      add_column :lab_criteria, :skill5, :text
  end
end
