class PagesController < ApplicationController
 
  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
  
  def safety
    @title = "Safety"
  end
  
  def terms
    @title = "Terms and Conditions"
  end
  
  def help
    @title = "Help"
  end
  
  def find
    @title = "Find"
  end
  

  def dashboard
    authenticate_user!
    
    @title    = "Dashboard"
    @user     = current_user
    @items    = @user.top_items
    @messages = @user.top_messages
    
       
  end

  def inbox
    authenticate_user!
    
    @title = "Inbox"
    @user = current_user
   
  end

 def profile
    authenticate_user!
    
    @title = "Profile"
    @user = current_user
   
  end
 def account
    authenticate_user!
    
    @title = "Account"
    @user = current_user
   
  end

  def rentals
    authenticate_user!
    
    @title = "Rentals"
    @user = current_user
   
  end
  
end
