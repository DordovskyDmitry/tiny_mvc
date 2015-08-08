class ProductsController < TinyMVC::BaseController
  layout 'app/views/layout.html.erb'

  def index
    @products = Product.all
    render 'app/views/products/index'
  end

  def new
    @product = Product.new
    render 'app/views/products/new'
  end

  def create
    @product = Product.new(params['product'])
    if @product.save.new_record?
      render 'app/views/products/new'
    else
      redirect_to '/products'
    end
  end

  def show
    @product = Product.find(params['id'])
    render 'app/views/products/show'
  end

  def edit
    @product = Product.find(params['id'])
    render 'app/views/products/edit'
  end

  def update
    @product = Product.find(params['id'])
    params['product'].each {|k,v| @product.send("#{k}=", v)}
    @product.save
    redirect_to '/products'
  end

  def destroy
    product = Product.find(params['id'])
    product.delete if product
    redirect_to '/products'
  end
end
