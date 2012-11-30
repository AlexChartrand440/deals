module Sales
  class ProductsController < ApplicationController

    def index
      if params[:category_id]
        @items = Category.find(params[:category_id]).products
        @title = Category.find(params[:category_id]).name
      else
        @items = User.find(params[:brand_id]).products
        @title = "by " + User.find(params[:brand_id]).brand
      end    
    end

    def show
      @category = Category.find(params[:category_id]) if params[:category_id]
      @item = Product.find(params[:id])
    end

  end
end