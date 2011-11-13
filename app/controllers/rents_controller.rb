class RentsController < ApplicationController 
    
  include ApplicationHelper
    

    
  def available_for_user(tuser)
      rtn = []
      items = Item.all(conditions: { active: '1' } )
      items.each do | item |
          if ( has_access(item) == 1 ) 
           rtn.push(item);
        end
      end
      Kaminari.paginate_array(rtn)

  end
    
  def index
      @items = available_for_user(current_user).page(params[:page]).per(7);  # page
      # @items = Item.all(conditions: { active: '1' } ).page(params[:page]).per(4)
       respond_to do |format|
         format.html # index.html.erb
         format.json { render json: @items.to_json() }
     end
     
  end
    
  def search
        @items = Item.all(conditions: { active: '1' } ).page(params[:page]).per(4)
        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @items.to_json() }
        end
  end
  
  def new
    authenticate_user!
    @user = current_user
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
     item = Item.find(params[:id])
      
     access = has_access(item)
      
     if access != 1
         redirect_to root_path
         return
     end
     @item = item 
     respond_to do |format|
       format.html # index.html.erb
       format.json { render json: @item }
     end
    
  end

end
