class ProductsController < ApplicationController

  def index
    products_by_category = Category.find(params[:category_id]).products if params[:category_id]
    products_by_brand = User.find(params[:brand_id]).products if params[:brand_id]
    @items = products_by_category ? products_by_category : products_by_brand
    @title = products_by_category ? Category.find(params[:category_id]).name : "by " + User.find(params[:brand_id]).brand
  end

  def show
    @category = Category.find(params[:category_id]) if params[:category_id]
    @item = Product.find(params[:id])
  end

end