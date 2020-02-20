class Setting < ApplicationRecord

    def Setting.get_setting(name)
        s = Setting.find_by(name: name)
        if (s)
            return s.value
        else
            return nil
        end
    end

    def Setting.set_setting(key, val)
        setting = Setting.find_by(name: key)
        if (not setting)
            setting = Setting.new(name: key, value: val)
        else
            setting.value = val
        end
        setting.save()
    end

    def Setting.set_test()
        Setting.set_setting('INVOICE_SHARE', '/Users/si/invoice_share_test')
        Setting.set_setting('ROOT_DIR', '/Users/si/mm_server')
    end


end
