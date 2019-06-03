class CreateCostCentres < ActiveRecord::Migration[5.0]
  def change
    create_table :cost_centres do |t|
      t.string :name
      t.string :code
      t.string :description
      t.timestamps
    end
    CostCentre.create :name => "Manufacturing", :code => "MAN", :description => "Cost of Parts. Don't include machines and tools and packaging, but do include consumables like solder"
    CostCentre.create :name => "Research & Development", :code => "RND", :description => "Simon's pay, components and PCBs for prototyping"
    CostCentre.create :name => "Sales & Marketing", :code => "MAR", :description => "Trips to BETT, sending samples etc."
    CostCentre.create :name => "Overheads", :code => "INF", :description => "Include: machines and tools, shipping boxes, rent, utilities, internet, furniture etc"
    
  end
end


