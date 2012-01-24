

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
  
  def privacy
   @title = "Privacy"
  end
  
  def copyright
   @title = "Copyright"
  end
  
  def gitpush
    result =  `/home/ubuntu/deploy.bat`    
    redirect_to root_path
  end
  
  def list
    authenticate_user!
    @user = currq
    qent_user
    if @user.stores.empty?
       @store = Store.new(params[:store])
       @store.user_id = @user.id
       @store.activate
       if @store.save
          redirect_to edit_store_path(@store)
       else
          redirect_to :show
       end
    else
       redirect_to store_items_path(@user.stores.first)
    end
  end  
   
  def how
    authenticate_user!
    @title = "How"
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
