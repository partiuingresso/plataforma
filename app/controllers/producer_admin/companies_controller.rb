class ProducerAdmin::CompaniesController < ApplicationController
  load_resource except: [:create]
  authorize_resource

  def show
    balances = Wirecard::show_balances @company

    @future_balance = Money.new(balances.future.first.amount).format
    @unavailable_balance = Money.new(balances.unavailable.first.amount).format
    @current_balance = Money.new(balances.current.first.amount).format
    available = [0, (balances.current.first.amount - balances.unavailable.first.amount)].max
    @available_balance = Money.new(available).format

    @new_transfer = @company.transfers.build

    @history_transfers = Kaminari.paginate_array(@company.transfers).page(params[:page]).per(10)
  end

  def new
    if current_user.company.present?
      redirect_to producer_admin_dashboard_path
    end
  end

  def create
    puts "*" * 100
    puts account_params.inspect
    puts "*" * 100
  end

  def edit
    @staff = User.where(company_id: @company.id)
    @user = User.new
  end

  def update
    if user_params[:email].present?
      @user = User.find_by(email: user_params[:email])
      if @user.present?
        @user.company_id = @company.id
        @user.update(user_params)
      else
        redirect_to edit_company_path(@company), alert: "Usuário não encontrado." and return
      end
    end

    if @company.update(company_params)
      redirect_to edit_company_path(@company), notice: "Empresa atualizada com sucesso."
    else
      redirect_to edit_company_path(@company), alert: "Ops... Algo deu errado! Tente novamente."
    end
  end

  def remove_staff
    @user = User.find(params[:user_id])
    @company = @user.company
    if @user.update(role: :user, company_id: nil)
      redirect_to edit_company_path(@company), notice: "Usuário removido."
    else
      redirect_to edit_company_path(@company), alert: "Ops... Algo deu errado! Tente novamente."
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

  def company_params
    params.require(:company).permit(:name, :email)
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end

  def current_ability
    @current_ability ||= ProducerAdmin::CompanyAbility.new(current_user)
  end
end
