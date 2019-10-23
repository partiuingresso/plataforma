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
    @seller = current_user.seller
    @staff_users = @seller.staff_users
    @user = User.new
  end

  def update
    if user_params[:email].present?
      result = CreateSellerStaff.call(@seller, user_params)

      if result.success? && @seller.update(seller_params)
        redirect_to edit_producer_admin_seller_path(@seller), notice: "Produtor atualizado com sucesso."
      else
        msg = result.full_error_message.present? ? result.full_error_message : "Ops... Algo deu errado! Tente novamente."
        redirect_to edit_producer_admin_seller_path(@seller), alert: msg
      end
    else

      if @seller.update(seller_params)
        redirect_to edit_producer_admin_seller_path(@seller), notice: "Produtor atualizado com sucesso."
      else
        redirect_to edit_producer_admin_seller_path(@seller), alert: "Ops... Algo deu errado! Tente novamente."
      end
    end
  end

  def remove_staff
    @seller = current_user.seller
    result = RemoveSellerStaff.call(@seller, params)
    if result.success?
      redirect_to edit_producer_admin_seller_path(@seller), notice: "Usuário removido."
    else
      redirect_to edit_producer_admin_seller_path(@seller), alert: "Ops... Algo deu errado! Tente novamente."
    end
  end

private

  def seller_params
    params.require(:seller).permit(:email, company_attributes: [:id, :name])
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end

  def current_ability
    @current_ability ||= ProducerAdmin::SellerAbility.new(current_user)
  end
end
