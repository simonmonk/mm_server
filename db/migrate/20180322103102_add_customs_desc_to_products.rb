class AddCustomsDescToProducts < ActiveRecord::Migration[5.0]
  def change
      add_column :products, :customs_description, :string
  end
end
