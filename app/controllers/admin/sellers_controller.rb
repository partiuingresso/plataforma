class Admin::SellersController < ApplicationController
  load_and_authorize_resource

  def show
    balances = Wirecard::show_balances @seller

    @future_balance = Money.new(balances.future.first.amount).format
    @unavailable_balance = Money.new(balances.unavailable.first.amount).format
    @current_balance = Money.new(balances.current.first.amount).format
    available = [0, (balances.current.first.amount - balances.unavailable.first.amount)].max
    @available_balance = Money.new(available).format

    @new_transfer = @seller.transfers.build

    @history_transfers = Kaminari.paginate_array(@seller.transfers).page(params[:page]).per(10)
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

  def edit
    # @staff = User.where(seller_id: @seller.id)
    @seller = Seller.find(params[:id])
    @staff = []
    @user = User.new
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
