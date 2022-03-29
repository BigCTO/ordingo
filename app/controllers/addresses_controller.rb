class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /addresses
  def index
    @pagy, @addresses = pagy(Address.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @addresses
  end

  # GET /addresses/1 or /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @address = Address.new

    # Uncomment to authorize with Pundit
    # authorize @address
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses or /addresses.json
  def create
    @address = Address.new(address_params)

    # Uncomment to authorize with Pundit
    # authorize @address

    respond_to do |format|
      if @address.save
        format.html { redirect_to @address, notice: "Address was successfully created." }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1 or /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: "Address was successfully updated." }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1 or /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url, notice: "Address was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_address
    @address = Address.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @address
  rescue ActiveRecord::RecordNotFound
    redirect_to addresses_path
  end

  # Only allow a list of trusted parameters through.
  def address_params
    params.require(:address).permit(:customer_id, :street, :number, :city, :state, :zipcode, :country, :primary)

    # Uncomment to use Pundit permitted attributes
    # params.require(:address).permit(policy(@address).permitted_attributes)
  end
end
