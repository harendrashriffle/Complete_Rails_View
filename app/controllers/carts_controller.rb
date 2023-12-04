class CartsController < ApplicationController

  def new
    if current_user.type == "Customer"
      @cart = current_user.build_cart
    end
  end

  def create
    return redirect_to restaurants_path , alert: "You have no access to create cart" unless current_user.type == "Customer"
    return redirect_to cart_items_path, notice: "Here is your cart" if current_user.cart.present?
    @cart = current_user.build_cart
    return redirect_to cart_items_path, notice: "Cart Created successfully" if @cart.save
    render restaurants_path, alert: "Cart doesn't Created successfully"
  end

end
