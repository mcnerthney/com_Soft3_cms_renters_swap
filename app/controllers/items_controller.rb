class ItemsController < ApplicationController
  
  #controller for maintaining items
  
  before_filter :set_store
  # GET /items
  # GET /items.json
  def index

    if @store.nil? || @store.user_id != current_user.id
      redirect_to root_path
    else
      @items = @store.items
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @items }
      end
    end
    
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    if @item.nil? || @item.store.user_id != current_user.id 
      redirect_to root_path
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @item }
      end
    end
    
  end

  # GET /items/new
  # GET /items/new.json
  def new
        
    @item = Item.new
    @item.store = @store
    @item.activate
    @item.set_default_access
      
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end

  end
  # GET /items/1/edit
  def edit
    if @store.nil? || @store.user_id != current_user.id
      redirect_to root_path
    else
    
    @item = Item.find(params[:id])
        
    respond_to do |format|
       format.html
    end

  end
end

  # POST /items
  # POST /items.json
  def create
    if @store.nil? || @store.user_id != current_user.id
      redirect_to root_path
    else
    
    @item = Item.new(params[:item])
    @item.activate

    
    @item.store = @store
    respond_to do |format|
      if @item.save
        format.html    { redirect_to store_items_path(@store), notice: 'Item was successfully created.' }
        format.json    { render json: @item, status: :created, location: @item }
      else
        format.html {  render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
    end
    
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    if @store.nil? || @store.user_id != current_user.id
      redirect_to root_path
    else
    
    @item = Item.find(params[:id])
 
    respond_to do |format|
      if @item.update_attributes(params[:item])
       format.html { redirect_to store_items_path(@store), notice: 'Item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    if @store.nil? || @store.user_id != current_user.id
      redirect_to root_path
    else
    
      @item = Item.find(params[:id])
      @item.destroy

      respond_to do |format|
        format.html    { redirect_to store_items_path(@store) }
        format.json    { head :ok }
      end
    end
  end
  
  private
    def set_store
      if  !current_user.nil? 
        @store = Store.find_by_id_and_user(params[:store_id], current_user)
      end
    end

  
end
