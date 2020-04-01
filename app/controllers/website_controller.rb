require 'fileutils'

class WebsiteController < ApplicationController

    # Website page generation code
    def home
        render :layout => false
    end

    def product_page
        @product = Product.find(params[:id])
        render :layout => false
    end

    def products
        render :layout => false
    end

    # Controlling page for website generation
    def index
    end



    def generate_files
        log = ''
        temp_dir = Setting.get_setting('TEMP_DIR')
        website_dir = temp_dir + "website/"
        rails_dir = Setting.get_setting('ROOT_DIR')
        if (not temp_dir)
            temp_dir = '/tmp/'
            Setting.set_setting('TEMP_DIR', temp_dir)
        end
        if (File.directory?(temp_dir))
            log += "Temp dir exists"
        else
            log += "No temp dir: " + temp_dir + " create or change TEMP_DIR system setting"
            return render :json => { result: log }
        end

        log += "\nDeleting exisitng website folder"
        begin
            puts FileUtils.rm_rf(website_dir)
            log += "\nDirectory: " + website_dir + " deleted OK"
        rescue
            log += "\nDirectory: " + website_dir + " Could NOT be deleted (may not exist)"
            return render :json => { result: log }
        end

        log += "\nCreating website folder"
        begin
            Dir.mkdir(website_dir)
            log += "\nDirectory: " + website_dir + " created OK"
        rescue
            log += "\nDirectory: " + website_dir + " Could NOT be created"
            return render :json => { result: log }
        end

        log += "\nCopying images, CSS and JS libs"
        begin
            FileUtils.cp_r(rails_dir + "/public/img", website_dir)
            FileUtils.cp_r(rails_dir + "/public/js", website_dir)
            FileUtils.cp_r(rails_dir + "/public/vendor", website_dir)
            FileUtils.cp_r(rails_dir + "/public/css", website_dir)
            FileUtils.cp_r(rails_dir + "/public/privacy-policy.html", website_dir)
            FileUtils.cp_r(rails_dir + "/public/404.html", website_dir)
            FileUtils.cp_r(rails_dir + "/public/500.html", website_dir)
            log += "\nDirectory: " + website_dir + " copied OK"
        rescue
            log += "\nDirectory: " + website_dir + " Could NOT be copied"
            return render :json => { result: log }
        end

        log += "\nCreating home page"
        cmd = "curl http://localhost:3000/website/home > " + website_dir + "index.html &"
        system(cmd)

        log += "\nCreating products page"
        cmd = "curl http://localhost:3000/website/products > " + website_dir + "products.html &"
        system(cmd)

        log += "\nCreating pages for each product"
        Product.where(include_in_catalog: true).each do | product |
            log += "\nCreating page for " + product.name + " (" + product.webpage_name + ".html)"
            cmd = "curl http://localhost:3000/website/product_page?id=" + product.id.to_s + " > " + website_dir +  product.webpage_name + ".html &"
            system(cmd)
        end
        return render :json => { result: log }
    end

    def upload_files
        log = 'done'
        temp_dir = Setting.get_setting('TEMP_DIR')
        website_dir = temp_dir + "website/"
        scp_upload_command = Setting.get_setting('UPLOAD_COMMAND_HTML')
        system(scp_upload_command)

        return render :json => { result: log }
    end
end
