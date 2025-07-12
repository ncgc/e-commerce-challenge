module Carts
  class AddProductToCart
    attr_reader :cart, :product_id, :quantity

    def initialize(cart:, product_id:, quantity:)
      @cart = cart
      @product_id = product_id
      @quantity = quantity.to_i # Ensure quantity is an integer
    end

    def process
      product = Product.find_by(id: product_id)
      return ServiceResult.failure("Product not found.") unless product

      @cart_item = cart.cart_items.find_or_initialize_by(product_id: product.id)
      set_item_quantity

      if @cart_item.save
        ServiceResult.success(cart)
      else
        ServiceResult.failure(@cart_item.errors.full_messages)
      end
    rescue StandardError => e
      ServiceResult.failure("An unexpected error occurred: #{e.message}")
    end
  
    private

    def set_item_quantity
      if @cart_item.new_record?
        @cart_item.quantity = quantity
      else
        @cart_item.quantity += quantity
      end
    end
  end
end
