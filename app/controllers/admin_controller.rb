class AdminController < ApplicationController
  authorize_resource :class => false

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, alert: 'Oops! Entre em contato com o administrador'
  end

  def admin
    @companies = Company.all
  end

  def producer_admin
    balances = Wirecard::show_balances current_user.company
    total = balances.future.first.amount + balances.unavailable.first.amount + balances.current.first.amount
    @total_balance = Money.new(total).format
    @events = Event.where(company_id: current_user.company_id)
  end

  def reports
    @events = Event.where(company_id: current_user.company_id)
  end

  def manage_company
    @user = current_user
    if @user.update(company_id: params[:company_id])
      redirect_to backstage_path, notice: "Gerenciando #{Company.find(params[:company_id]).name}"
    else
      redirect_to backoffice_path, alert: "Ops... algo deu errado! Tente novamente."
    end
  end

end