class ProductsController < ApplicationController
  before_action :check_ownership, only: [:edit, :update]

  expose(:category)
  expose(:products, ancestor: :category) {category.products}
  expose(:product)
  expose(:review) { Review.new }
  expose_decorated(:reviews, ancestor: :product)

  def index
  end

  def show
  end

  def new
  end

  def edit
    
  end

  def create
    self.product = Product.new(product_params)

    if product.save
      category.products << product
      redirect_to category_product_url(category, product), notice: 'Product was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if self.product.update(product_params)
      redirect_to category_product_url(category, product), notice: 'Product was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /products/1
  def destroy
    product.destroy
    redirect_to category_url(product.category), notice: 'Product was successfully destroyed.'
  end

  private
    def product_params
      params[:product][:user_id] = current_user.id
      params.require(:product).permit(:title, :description, :price, :category_id, :user_id)
    end

    def check_ownership
      if product.user_id != current_user.id
        flash[:error] = "You are not allowed to edit this product."
        redirect_to category_product_url(category, product)
      end
    end
end
