class AddFieldsToSupplier < ActiveRecord::Migration[5.0]
  def change
      add_column :suppliers, :website, :string
      add_column :suppliers, :login_details, :string
      add_column :suppliers, :payment_details, :string
      add_column :suppliers, :active, :boolean
  end
end
