class ChangeIntTypes < ActiveRecord::Migration[5.0]
  def change
      change_table :parts do |t|
        t.change :cost, :decimal, :precision => 10, :scale => 3
        t.change :exch_rate, :decimal, :precision => 10, :scale => 3  
      end
      change_table :assemblies do |t|
        t.change :labour, :decimal, :precision => 10, :scale => 3
      end
        change_table :products do |t|
        t.change :labour, :decimal, :precision => 10, :scale => 3
      end
  end
end
