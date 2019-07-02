class CompaniesController < ApplicationController
  load_and_authorize_resource :except => :create

  def index
  end

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
    @company_form = CompanyForm.new
  end

  def edit
    @staff = User.where(company_id: @company.id)
    @user = User.new
  end

  def create
    @company_form = CompanyForm.new(permitted_params)
    respond_to do |format|
      if @company_form.save
        format.html { redirect_to backoffice_path, notice: 'Empresa criada com sucesso.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company_form.errors, status: :unprocessable_entity }
      end
    end
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

  def company_params
    params.require(:company).permit(:name, :email)
  end

  def permitted_params
    params.require(:company_form).permit(:name, :business_name, :document_number, :email, :phone,
                                    address_attributes: [:address, :number, :complement, :district, :city, :state, :zipcode],
                                    person_attributes: [:name, :document_number, :email, :phone, :birthdate,
                                    address: [:address, :number, :complement, :district, :city, :state, :zipcode]])
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end
end
