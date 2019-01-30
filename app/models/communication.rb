class Communication < ApplicationRecord

    belongs_to :prospect

    def from()
        if (user_id) 
            user = User.find(user_id)
            return user.name
        end
        return ""
    end

end
