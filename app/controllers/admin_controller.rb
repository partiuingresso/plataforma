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

end