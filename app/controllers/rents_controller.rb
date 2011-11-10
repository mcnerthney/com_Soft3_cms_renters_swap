class RentsController < ApplicationController 
    
  include ApplicationHelper
    
def has_access(i)
    access= 0
    
    
    if user_signed_in? && 
      ( current_user.admin? || i.store.user == current_user )
                       logger.debug "admin or current user"
      access = 1
    else
    
    
     if i.item_user_groups.where(everyone: true).first.nil?      
    
       if i.item_user_groups.where(all_fb_friends: true).first.nil?
    
          access = 0   
               logger.debug "no vaild user groups  #{i.store.user.email}"
    
       else
    
         if !user_signed_in?
           access = -1
                 logger.debug "fb friend - without signin"
          return
         end
       # must be in one of the owner's fb_friends.           

         if  current_user.fb_id.nil? 
             logger.debug "fb friend - without current_user.fb_id"
         else

           if i.store.user.fb_friends.where(fb_id: current_user.fb_id).first.nil?
              access = 0
                   logger.debug "fb friend no access #{i.id}"           
            else
            # current user is a friend of the store's owner
              access = 1
                   logger.debug "fb friend access #{i.id}"
           end
         end
      end
    else
       # everyone
      access = 1
             logger.debug "everyone access #{i.id}"
    end
  end
    access
 end


    
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
