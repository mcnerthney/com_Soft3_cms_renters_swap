class PhotosController < ApplicationController
  before_filter :find_item
  before_filter :find_or_build_photo, :except => [:index, :sort]

  def index
    redirect_to store_item_path(@item.store.id,@item.id)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @photo.save
      respond_to do |format|
        format.html { redirect_to store_item_path(@item.store.id, @item.id), :notice => 'Photo successfully created' }
        format.js
      end
    else
      render :new
    end
  end

  def update
    if @photo.update_attributes(params[:photo])
      redirect_to store_item_path(@item.store.id, @item.id), :notice => 'Photo successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @photo.destroy
    redirect_to store_item_path(@item.store.id, @item.id)
  end

  def sort
    # params[:photo] is an array of photo IDs in the order
    # the should be set in the item. Take each ID and it's
    # index in the array, find the photo with the ID and set
    # it's position to the index. Run through the whole ID 
    # array. Mongoid will automatically do an atomic update
    # of only the photos whose position has changed.
    params[:photo].each_with_index do |id, idx|
      @item.photos.find(id).position = idx
    end
    @item.save
    render :nothing => true
  end

private
  def find_item
    @item = Item.find(params[:item_id])
  end

  def find_or_build_photo
    @photo = params[:id] ? @item.photos.find(params[:id]) : @item.photos.build(params[:photo])
  end
end

