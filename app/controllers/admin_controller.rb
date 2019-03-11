class AdminController < ApplicationController
  authorize_resource :class => false

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, alert: 'Oops! Entre em contato com o administrador'
  end

  def admin
    @companies = Company.all
  end

  def producer_admin
  end

  def manage_company
    @user = current_user
    @user.update(company_id: params[:company_id])
    redirect_to backstage_path, notice: "Gerenciando #{Company.find(params[:company_id]).name}"
  end

end