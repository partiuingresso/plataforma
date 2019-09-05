class SellersController < ApplicationController
  def new
    if current_user.seller.present?
      redirect_to producer_admin_dashboard_path
    end
  end

  def create
    result = CreateSeller.call(current_user, account_params)
    if result.success?
      head :no_content
    else
      head :bad_request
    end
  end

  private

    def account_params
      params.require(:account).permit(
        :name,
        :email,
        :document_number,
        :birthdate,
        :phone,
        :show_phone,
        :help_email,
        address: [
          :zipcode,
          :address,
          :number,
          :complement,
          :district,
          :city,
          :state
        ],
        company: [
          :name,
          :business_name,
          :document_number,
          :phone,
          address: [
            :zipcode,
            :address,
            :number,
            :complement,
            :district,
            :city,
            :state
          ]
        ]
      )
    end
end
