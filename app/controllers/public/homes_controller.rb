class Public::HomesController < ApplicationController
  def top
    @items = Item.recommended
  end
end
