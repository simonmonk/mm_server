class Setting < ApplicationRecord

    def Setting.get_setting(name)
        s = Setting.find_by(name: name)
        if (s)
            return s.value
        else
            return nil
        end
    end

end
