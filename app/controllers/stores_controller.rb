class StoresController < ApplicationController
  
    before_filter :authenticate_user!

  
  # GET /stores
  # GET /stores.json
  def index
      @stores = Store.all(conditions: { user_id: current_user.id } )
      s = @stores.first
      if s.nil?
        redirect_to :action => :new
      else
        respond_to do |format|
          format.html # index.html.erb
        end
      end
      
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
     @store = Store.find(params[:id])
     @items = Item.all(conditions: { store_id: @store.id } ).page(params[:page]).per(4)
     respond_to do |format|
       format.html 
       # format.json { render json: @store }
     end
    

  end

  # GET /stores/1/edit
  def edit
    @store = Store.find(params[:id])
  end

  def new
     @store = Store.new
     @store.activate
     respond_to do |format|
       format.html # new.html.erb
     end

   end



  # POST /stores
  # POST /stores.json
  def create

    @store = Store.new(params[:store])
    @store.user_id = current_user.id
    
      respond_to do |format|
        if @store.save
          format.html { redirect_to new_store_item_path(@store), notice: 'Store was successfully created.' }
          format.json { render json: @store, status: :created, location: @store }
        else
          format.html { render action: "new" }
          format.json { render json: @store.errors, status: :unprocessable_entity }
        end
      end

  end

  # PUT /stores/1
  # PUT /stores/1.json
  def update
    @store = Store.find(params[:id])

    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to store_items_path(@store), notice: 'Store was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store = Store.find(params[:id])
    @store.deactivate
    @store.save

    respond_to do |format|
      format.html { redirect_to stores_url }
      format.json { head :ok }
    end
  end
  
  
    
end
