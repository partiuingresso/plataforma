class AdminController < ApplicationController

  def admin
    @companies = Company.all
    
    unless current_user.admin?
      redirect_to root_path, alert: 'Oops'
    end
  end

  def producer_admin
    unless current_user.company.present?
      redirect_to root_path, alert: 'Entre em contato com o administrador'
    end
  end

end