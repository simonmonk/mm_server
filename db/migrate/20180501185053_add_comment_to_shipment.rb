class AddCommentToShipment < ActiveRecord::Migration[5.0]
  def change
      add_column :shipments, :invoice_comment, :string
  end
end
