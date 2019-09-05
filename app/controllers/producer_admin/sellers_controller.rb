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
        redirect_to edit_producer_admin_seller_path(@seller), alert: "Usuário não encontrado." and return
      end
    end

    if @seller.update(seller_params)
      redirect_to edit_producer_admin_seller_path(@seller), notice: "Vendedor atualizado com sucesso."
    else
      redirect_to edit_producer_admin_seller_path(@seller), alert: "Ops... Algo deu errado! Tente novamente."
    end
  end

  def remove_staff
    @user = User.find(params[:user_id])
    @seller = @user.seller
    if @user.update(role: :user, seller_id: nil)
      redirect_to edit_producer_admin_seller_path(@seller), notice: "Usuário removido."
    else
      redirect_to edit_producer_admin_seller_path(@seller), alert: "Ops... Algo deu errado! Tente novamente."
    end
  end

private

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
