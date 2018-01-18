class ChangeDataTypeForFieldname < ActiveRecord::Migration[5.0]
  def self.up
    change_table :products do |t|
      t.change :labour, :float
    end
  end
  def self.down
    change_table :products do |t|
      t.change :labour, :float
    end
  end
end