class WelcomeController < ApplicationController
  def index
  end

  def sales
  end
    
  def dismiss_notification()
    id = params[:id]
    n = Notification.find(id)
    n.dismissed = true
    n.save
    redirect_to :action => "index"  
  end
    
  def restore_notifications()
    Notification.all.each do |n|
        n.dismissed = false
        n.save
    end
    redirect_to :action => "index"  
  end
    
end