class Admin::SellersController < ApplicationController
  authorize_resource

   def show
    @seller = Seller.find(params[:id])
    @user = current_user
    if @user.update(seller: @seller)
      redirect_to producer_admin_dashboard_path, notice: "Gerenciando #{@seller.name}"
    else
      redirect_to backoffice_path, alert: "Ops... algo deu errado! Tente novamente."
    end
  end

  def new
    @seller_form = SellerForm.new
  end

  def create
    @seller_form = SellerForm.new(permitted_params)
    respond_to do |format|
      if @seller_form.save
        format.html { redirect_to admin_dashboard_path, notice: 'Vendedor criado com sucesso.' }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @seller_form.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def permitted_params
    params.require(:seller_form).permit(:name, :business_name, :document_number, :email, :phone,
                                    address_attributes: [:address, :number, :complement, :district, :city, :state, :zipcode],
                                    person_attributes: [:name, :document_number, :email, :phone, :birthdate,
                                    address: [:address, :number, :complement, :district, :city, :state, :zipcode]])
  end

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end
end
