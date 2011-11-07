class RentsController < ApplicationController  
  def index
      if ( user_signed_in? && current_user.fb_auth_token != nil )
          @me = FbGraph::User.me(current_user.fb_auth_token)
          @friend_list = Array.new
          @me.friends.each do |friend|
              friend.picture
              @friend_list.push(friend.picture)

          end
      end

       @items = Item.all(conditions: { active: '1' } ).page(params[:page]).per(4)
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
     @item = Item.find(params[:id])
     respond_to do |format|
       format.html # index.html.erb
       format.json { render json: @item }
     end
    
  end

end
