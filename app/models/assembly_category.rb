class AssemblyCategory < ApplicationRecord

    has_many :assemblies

    def active_assemblies
        assemblies.select { | a | a.active }
    end

    def as_json(options={})
        super(:methods => [:active_assemblies])
    end  

end
