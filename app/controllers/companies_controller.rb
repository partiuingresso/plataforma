class CompaniesController < ApplicationController
load_and_authorize_resource

  def index
  end

  def show
    balances = Wirecard::show_balances @company
    total = balances.future.first.amount + balances.unavailable.first.amount + balances.current.first.amount

    @total_balance = Money.new(total).format
    @future_balance = Money.new(balances.future.first.amount).format
    @unavailable_balance = Money.new(balances.unavailable.first.amount).format
    @current_balance = Money.new(balances.current.first.amount).format

    @new_transfer = @company.transfers.build
  end

  def new
    @company.build_address
    @user = current_user
    @user.build_address
  end

  def edit
    @staff = User.where(company_id: @company.id)
    @user = User.new
  end

  def create
    current_user.assign_attributes(user_params)
    account = Wirecard::create_account current_user, @company
    unless account.respond_to?(:id) && account.id.present?
      redirect_to new_company_path, alert: 'Ops... algo deu errado! Tente novamente.' and return
    end
    @company.moip_id = account.id
    @company.moip_access_token = account.access_token

    respond_to do |format|
      if current_user.save && @company.save
        format.html { redirect_to backoffice_path, notice: 'Empresa criada com sucesso.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find_by(email: params[:email])

    if params[:email].present? && user_params[:role].nil? && @user.nil?
      redirect_to backstage_path, alert: 'Usuário não encontrado' and return
    elsif params[:email].present?
      @user.update(role: user_params[:role].to_i, company_id: @company.id)
    end

    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to backstage_path, notice: 'Empresa atualizada com sucesso.' } if current_user.producer_admin?
        format.html { redirect_to backoffice_path, notice: 'Empresa atualizada com sucesso.' } if current_user.admin?
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_staff
    @user = User.find(params[:user_id])
    if @user.update(role: 0, company_id: nil)
      redirect_to backoffice_path, notice: 'Usuário removido' if current_user.admin?
      redirect_to backstage_path, notice: 'Usuário removido' if current_user.producer_admin?
    else
      redirect_to backstage_path, alert: 'Erro'
    end
  end

private

  def company_params
    params.require(:company).permit(:name, :business_name, :document_number, :phone,
                                    address_attributes: [:address, :number, :complement, :district, :city, :state, :zipcode])
  end

  def user_params
    params.require(:user).permit(:email, :role, :cpf, :phone, :birthday,
                                 address_attributes: [:address, :number, :complement, :district, :city, :state, :zipcode])
  end

end
