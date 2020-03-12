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

    def Website.product_head_blurb()
        return Setting.get_setting('WEBSITE_PRODUCT_HEAD_BLURB')
    end

    def Website.product_detail_blurb()
        return Setting.get_setting('WEBSITE_PRODUCT_DETAIL_BLURB')
    end
    
        
    def Website.carousel_images()
        images = []
        for i in 0..3 do
            im = Setting.send('get_setting', "WEBSITE_CAROUSEL_" + i.to_s)
            if (im and im.length > 2)
                images.append(im)
            end
        end
        return images
    end

end