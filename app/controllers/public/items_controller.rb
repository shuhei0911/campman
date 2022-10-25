class Public::ItemsController < ApplicationController
  
  before_action :search
  
  def top
    @items = Item.recommended
  end
  
  def search
    @q = Item.ransack(params[:q])
  end

  def index
    @items = Item.all
    @items = @q.result(distinct: true)
  end

  def show
    @item = Item. find(params[:id])
    @cart_item = CartItem.new
    @comment = Comment.new
  end



end