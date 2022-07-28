class Public::ItemsController < ApplicationController
  def top
    @items = Item.recommended
  end

  def index
    @items = Item.all
  end

  def show
    @item = Item. find(params[:id])
    @cart_item = CartItem.new
    @comment = Comment.new
  end

  def search
    @items = Item.search(params[:keyword])
    @keyword = params[:keyword]
    render "index"
  end

end