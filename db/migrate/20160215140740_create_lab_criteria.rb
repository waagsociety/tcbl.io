class CreateLabCriteria < ActiveRecord::Migration
  def change
    create_table :lab_criteria do |t|
      t.integer :lab_id
      t.string :principle1
      t.string :principle2
      t.string :principle3
      t.string :principle4
      t.string :principle5
      t.string :principle6
      t.string :principle7
      t.string :service1
      t.string :service2
      t.string :service3
      t.string :service4
      t.string :service5
      t.text :network

      t.timestamps
    end
  end
end
