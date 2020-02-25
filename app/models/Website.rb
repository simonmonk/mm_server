class Website

    # This is not a model, its just a place for website related utility functions

    def Website.strap_line()
        return Setting.get_setting('STRAP_LINE')
    end

    def Website.homepage_blurb()
        return Setting.get_setting('HOMEPAGE_BLURB')
    end
    
    def Website.distributers_blurb()
        return Setting.get_setting('WEBSITE_DISTRIBUTERS_BLURB')
    end

    def Website.become_reller_blurb()
        return Setting.get_setting('WEBSITE_BECOME_RESELLER_BLURB')
    end
        
    

end