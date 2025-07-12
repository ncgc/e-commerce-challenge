class CartsController < ApplicationController
  include ActiveModel::Serialization

  # POST /cart
  def add_product
    service = Carts::AddProductToCart.new(
      cart: set_cart,
      product_id: cart_params[:product_id],
      quantity: cart_params[:quantity]
    )

    result = service.process

    if result.success?
      render json: cart_response(result.value), status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def cart_params
    params.permit(:product_id, :quantity)
  end

  def set_cart
    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id])
      return cart if cart
    end

    cart = Cart.create!
    session[:cart_id] = cart.id
    cart
  end

  ## TODO: add serializers
  def cart_response(cart)
    {
      id: cart.id,
      products: cart.cart_items.map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.total_price
        }
      end,
      total_price: cart.total_price
    }
  end
end
