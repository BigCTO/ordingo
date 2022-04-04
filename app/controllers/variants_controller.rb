class VariantsController < ApplicationController
  before_action :set_variant, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /variants
  def index
    @pagy, @variants = pagy(Variant.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @variants
  end

  # GET /variants/1 or /variants/1.json
  def show
  end

  # GET /variants/new
  def new
    @variant = Variant.new

    # Uncomment to authorize with Pundit
    # authorize @variant
  end

  # GET /variants/1/edit
  def edit
  end

  # POST /variants or /variants.json
  def create
    @variant = Variant.new(variant_params)
    puts "variant_params #{variant_params}"

    # Uncomment to authorize with Pundit
    # authorize @variant

    respond_to do |format|
      if @variant.save
        format.html { redirect_to @variant, notice: "Variant was successfully created." }
        format.json { render :show, status: :created, location: @variant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variants/1 or /variants/1.json
  def update
    respond_to do |format|
      if @variant.update(variant_params)
        format.html { redirect_to @variant, notice: "Variant was successfully updated." }
        format.json { render :show, status: :ok, location: @variant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variants/1 or /variants/1.json
  def destroy
    @variant.destroy
    respond_to do |format|
      format.html { redirect_to variants_url, notice: "Variant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_variant
    @variant = Variant.friendly.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @variant
  rescue ActiveRecord::RecordNotFound
    redirect_to variants_path
  end

  # Only allow a list of trusted parameters through.
  def variant_params
    params.require(:variant).permit(:account_id, :product_id, :name, :description, :price, :weight, :inventory)

    # Uncomment to use Pundit permitted attributes
    # params.require(:variant).permit(policy(@variant).permitted_attributes)
  end
end
