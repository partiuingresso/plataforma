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

  def edit
    @staff_users = @seller.staff_users
    @user = User.new
  end

  def update
    if user_params[:email].present?
      result = CreateSellerStaff.call(@seller, user_params)

      if result.success? && @seller.update(seller_params)
        redirect_to edit_admin_seller_path(@seller), notice: "Produtor atualizado com sucesso."
      else
        msg = result.full_error_message.present? ? result.full_error_message : "Ops... Algo deu errado! Tente novamente."
        redirect_to edit_admin_seller_path(@seller), alert: msg
      end
    else

      if @seller.update(seller_params)
        redirect_to edit_admin_seller_path(@seller), notice: "Produtor atualizado com sucesso."
      else
        redirect_to edit_admin_seller_path(@seller), alert: "Ops... Algo deu errado! Tente novamente."
      end
    end
  end

  def remove_staff
    @seller = Seller.find(params[:seller_id])
    result = RemoveSellerStaff.call(@seller, params)
    if result.success?
      redirect_to edit_admin_seller_path(@seller), notice: "Usuário removido."
    else
      redirect_to edit_admin_seller_path(@seller), alert: "Ops... Algo deu errado! Tente novamente."
    end
  end

private

  def seller_params
    params.require(:seller).permit(:name, :email)
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end

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
