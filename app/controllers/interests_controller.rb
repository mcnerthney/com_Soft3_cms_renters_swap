class InterestsController < ApplicationController
  
  def new  
     @interest = Interest.new
        respond_to do |format|
         format.html # show.html.erb
       end
   end
   
   # POST /survey
    def create
  
      @interest = Interest.new(params[:interest])
      if @interest.save
        redirect_to  rents_path, :flash => { :success => "Thank you for your interest." }
      else
        render 'new'
      end
    end

end
