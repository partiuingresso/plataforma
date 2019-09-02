class ProducerAdmin::SellersController < ApplicationController
  load_resource except: [:create]
  authorize_resource

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

  def edit
    @staff = User.where(seller_id: @seller.id)
    @user = User.new
  end

  def update
    if user_params[:email].present?
      @user = User.find_by(email: user_params[:email])
      if @user.present?
        @user.seller_id = @seller.id
        @user.update(user_params)
      else
        redirect_to edit_seller_path(@seller), alert: "Usuário não encontrado." and return
      end
    end

    if @seller.update(seller_params)
      redirect_to edit_seller_path(@seller), notice: "Vendedor atualizado com sucesso."
    else
      redirect_to edit_seller_path(@seller), alert: "Ops... Algo deu errado! Tente novamente."
    end
  end

  def remove_staff
    @user = User.find(params[:user_id])
    @seller = @user.seller
    if @user.update(role: :user, seller_id: nil)
      redirect_to edit_seller_path(@seller), notice: "Usuário removido."
    else
      redirect_to edit_seller_path(@seller), alert: "Ops... Algo deu errado! Tente novamente."
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

  def seller_params
    params.require(:seller).permit(:name, :email)
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end

  def current_ability
    @current_ability ||= ProducerAdmin::SellerAbility.new(current_user)
  end
end
