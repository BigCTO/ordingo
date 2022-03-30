class WebhookEndpointsController < ApplicationController
  before_action :set_webhook_endpoint, only: [:show, :edit, :update, :destroy, :change_enabled]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /webhook_endpoints
  def index
    @pagy, @webhook_endpoints = pagy(WebhookEndpoint.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @webhook_endpoints
  end

  # GET /webhook_endpoints/1 or /webhook_endpoints/1.json
  def show
  end

  # GET /webhook_endpoints/new
  def new
    @webhook_endpoint = WebhookEndpoint.new

    # Uncomment to authorize with Pundit
    # authorize @webhook_endpoint
  end

  # GET /webhook_endpoints/1/edit
  def edit
  end

  # POST /webhook_endpoints or /webhook_endpoints.json
  def create
    @webhook_endpoint = WebhookEndpoint.new(final_params)

    # Uncomment to authorize with Pundit
    # authorize @webhook_endpoint

    respond_to do |format|
      if @webhook_endpoint.save
        format.html { redirect_to @webhook_endpoint, notice: "Webhook endpoint was successfully created." }
        format.json { render :show, status: :created, location: @webhook_endpoint }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @webhook_endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /webhook_endpoints/1 or /webhook_endpoints/1.json
  def update
    respond_to do |format|
      if @webhook_endpoint.update(final_params)
        format.html { redirect_to @webhook_endpoint, notice: "Webhook endpoint was successfully updated." }
        format.json { render :show, status: :ok, location: @webhook_endpoint }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @webhook_endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webhook_endpoints/1 or /webhook_endpoints/1.json
  def destroy
    @webhook_endpoint.destroy
    respond_to do |format|
      format.html { redirect_to webhook_endpoints_url, notice: "Webhook endpoint was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def change_enabled
    @webhook_endpoint.update(enabled: !@webhook_endpoint.enabled)
    render json: { success: true }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_webhook_endpoint
    @webhook_endpoint = WebhookEndpoint.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @webhook_endpoint
  rescue ActiveRecord::RecordNotFound
    redirect_to webhook_endpoints_path
  end

  def final_params
    enabled = if webhook_endpoint_params[:enabled].present?
                true
              else
                false
              end
    webhook_endpoint_params.merge(account_id: current_account.id, enabled: enabled)
  end

  # Only allow a list of trusted parameters through.
  def webhook_endpoint_params
    # params.fetch(:webhook_endpoint, {:target_url, :event_types, :enabled})

    # Uncomment to use Pundit permitted attributes
    params.require(:webhook_endpoint).permit(:target_url, :enabled, :event_types => [])
  end
end
