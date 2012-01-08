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
  
end
