class CartController < TinyMVC::BaseController
  layout 'app/views/layout.html.erb'

  def update
    product = Product.find(params['id'])
    if product
      session[:cart] = Cart.add_product(session[:cart], product)
      redirect_to('/products')
    else
      raise TinyMVC::NotFoundException, 'Product not found'
    end
  end

  def show
    @cart = session[:cart] || Cart.new
    @products = @cart.products.group_by(&:id)
    render 'app/views/cart/show'
  end
end
