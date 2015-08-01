class Cart
  attr_accessor :products

  def initialize(products = [])
    @products = products
  end

  def self.add_product(cart, product)
    cart ||= Cart.new
    cart.add(product)
    cart
  end

  def add(product)
    raise(ArgumentError, "#{product} is not a Product") unless product.is_a?(Product)
    @products << product
  end

  def delete(product_name)
    @products.reject! { |product| product.name == product_name }
  end

  def total_price
    @products.map(&:price).map(&:to_i).reduce(&:+)
  end
end
