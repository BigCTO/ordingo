# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :authenticate_user!
  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /products
  def index
    @pagy, @products = pagy(Product.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @products
  end

  # GET /products/1 or /products/1.json
  def show; end

  # GET /products/new
  def new
    @product = Product.new
    @product.variants.build
    # Uncomment to authorize with Pundit
    # authorize @product
  end

  # GET /products/1/edit
  def edit; end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    # Uncomment to authorize with Pundit
    # authorize @product

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_image_attachment
    ActiveStorage::Attachment.find(params[:id]).purge
    redirect_back(fallback_location: root_path)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.friendly.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @product
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(
      :account_id, :name, :status, :image, :description,
      product_options_attributes: %i[id name value _destroy],
      variants_attributes: [:id, :name, :description, :price, :sku, :inventory, :_destroy, :image,
                            { standard_pricing_attributes: %i[id price _destroy],
                              subscription_pricings_attributes: %i[id interval_count interval price _destroy],
                              bundles_attributes: %i[id product_id bundled_product_id quantity _destroy],
                              }]
    )

    # Uncomment to use Pundit permitted attributes
    # params.require(:product).permit(policy(@product).permitted_attributes)
  end
end
