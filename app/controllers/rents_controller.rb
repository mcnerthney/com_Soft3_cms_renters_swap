class RentsController < ApplicationController

  before_filter :set_user
  before_filter :authenticate_user! , :only => :new
  
  def index
    
       @items = Item.all(conditions: { active: '1' } )
       respond_to do |format|
         format.html # index.html.erb
         format.json { render json: @items.to_json() }
     end
     
  end
  
  def new
    if @user.stores.empty?
       @store = Store.new(params[:store])
       @store.user_id = @user.id
       @store.activate
       if @store.save
          redirect_to new_store_item_path(@store)
       else
          redirect_to :show
       end
    else
       redirect_to new_store_item_path(@user.stores.first)
    end
    
end  

  
  
  def show
     @item = Item.find(params[:id])
     respond_to do |format|
       format.html # index.html.erb
       format.json { render json: @item }
     end
    
  end
  private
     def set_user
       @user =  current_user
     end      

end
