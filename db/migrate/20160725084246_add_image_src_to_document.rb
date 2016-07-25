class AddImageSrcToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :image_src, :string
  end
end
