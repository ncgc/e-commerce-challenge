class CartItemSerializer < ActiveModel::Serializer
  attributes :quantity, :total_price

  belongs_to :product
  belongs_to :cart
end