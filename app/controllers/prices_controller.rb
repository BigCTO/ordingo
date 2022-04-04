class PricesController < ApplicationController
  before_action :set_price, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /prices
  def index
    @pagy, @prices = pagy(Price.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @prices
  end

  # GET /prices/1 or /prices/1.json
  def show
  end

  # GET /prices/new
  def new
    @price = Price.new

    # Uncomment to authorize with Pundit
    # authorize @price
  end

  # GET /prices/1/edit
  def edit
  end

  # POST /prices or /prices.json
  def create
    @price = Price.new(price_params)

    # Uncomment to authorize with Pundit
    # authorize @price

    respond_to do |format|
      if @price.save
        format.html { redirect_to @price, notice: "Price was successfully created." }
        format.json { render :show, status: :created, location: @price }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prices/1 or /prices/1.json
  def update
    respond_to do |format|
      if @price.update(price_params)
        format.html { redirect_to @price, notice: "Price was successfully updated." }
        format.json { render :show, status: :ok, location: @price }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prices/1 or /prices/1.json
  def destroy
    @price.destroy
    respond_to do |format|
      format.html { redirect_to prices_url, notice: "Price was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_price
    @price = Price.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @price
  rescue ActiveRecord::RecordNotFound
    redirect_to prices_path
  end

  # Only allow a list of trusted parameters through.
  def price_params
    params.require(:price).permit(:order_id, :total, :subtotal, :discount_amount, :tax_amount, :shipping_fee)

    # Uncomment to use Pundit permitted attributes
    # params.require(:price).permit(policy(@price).permitted_attributes)
  end
end
