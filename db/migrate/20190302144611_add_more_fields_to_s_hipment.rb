class AddMoreFieldsToSHipment < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :invoice_exch_rate, :decimal, :precision => 10, :scale => 3
    add_column :shipments, :weight_kg, :decimal, :precision => 10, :scale => 3
    add_column :shipments, :width_cm, :decimal, :precision => 10, :scale => 3
    add_column :shipments, :height_cm, :decimal, :precision => 10, :scale => 3
    add_column :shipments, :depth_cm, :decimal, :precision => 10, :scale => 3
  end
end
