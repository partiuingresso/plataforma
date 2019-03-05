class CompaniesController < ApplicationController
load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
    @staff = User.where(company_id: @company.id)
    @user = User.new
  end

  def create
    account = Wirecard::create_account
    unless account.respond_to?(:id) && account.id.present?
      redirect_to new_company_path, alert: 'Ops... algo deu errado! Tente novamente.' and return
    end
    @company.moip_id = account.id
    @company.moip_access_token = account.access_token

    respond_to do |format|
      if @company.save
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

    if params[:email].present? && update_params[:role].nil? && @user.nil?
      redirect_to backstage_path, alert: 'Usuário não encontrado' and return
    elsif params[:email].present?
      @user.update(role: update_params[:role].to_i, company_id: @company.id)
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
    params.require(:company).permit(:name)
  end

  def update_params
    params.require(:user).permit(:email, :role)
  end

end
