class AddRatioToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :ratio, :string
  end
end
