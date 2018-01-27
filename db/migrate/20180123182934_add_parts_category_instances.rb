class AddPartsCategoryInstances < ActiveRecord::Migration[5.0]
  def change
    PartCategory.create :name => 'Booklets and Cards'
    PartCategory.create :name => 'Packaging Bags and Labels'
    PartCategory.create :name => 'Resistors'
    PartCategory.create :name => 'Capacitors'
    PartCategory.create :name => 'LEDs'
    PartCategory.create :name => 'Transistors and Diodes'
    PartCategory.create :name => 'ICs'
    PartCategory.create :name => 'Motors'
    PartCategory.create :name => 'Wire and Connectors'
    PartCategory.create :name => 'Modules'
    PartCategory.create :name => 'PCBs'
    PartCategory.create :name => 'Tools'
    PartCategory.create :name => 'Other Components'
    PartCategory.create :name => 'Laser Materials and Chassis'
    PartCategory.create :name => 'No Longer Used'
    PartCategory.create :name => 'UNCATEGORIZED'
  end
end
