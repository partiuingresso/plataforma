class Admin::CompaniesController < ApplicationController
  authorize_resource

   def show
    @company = Company.find(params[:id])
    @user = current_user
    if @user.update(company: @company)
      redirect_to producer_admin_dashboard_path(@company), notice: "Gerenciando #{@company.name}"
    else
      redirect_to backoffice_path, alert: "Ops... algo deu errado! Tente novamente."
    end
  end

  def new
    @company_form = CompanyForm.new
  end

  def create
    @company_form = CompanyForm.new(permitted_params)
    respond_to do |format|
      if @company_form.save
        format.html { redirect_to admin_dashboard_path, notice: 'Empresa criada com sucesso.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company_form.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def permitted_params
    params.require(:company_form).permit(:name, :business_name, :document_number, :email, :phone,
                                    address_attributes: [:address, :number, :complement, :district, :city, :state, :zipcode],
                                    person_attributes: [:name, :document_number, :email, :phone, :birthdate,
                                    address: [:address, :number, :complement, :district, :city, :state, :zipcode]])
  end

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end
end
