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
    if balances.respond_to?(:future) && balances.future.present?
      total = balances.future.first.amount + balances.unavailable.first.amount + balances.current.first.amount
      @total_balance = Money.new(total).format
    else
      @total_balance = "Not Responding."
    end
    
    @events = Event.where(company_id: current_user.company_id).order(created_at: :desc).to_happen
  end

  def report
    @event = Event.find(params[:id])
    if params[:offer].present?
      if search_params[:q].present?
        @offer = Offer.find(params[:offer])
        @search_order = @offer.orders.search_order(search_params[:q])
        @orders = Kaminari.paginate_array(@search_order).page(params[:page]).per(10)
      else
        @offer = Offer.find(params[:offer])
        @all_orders = @offer.orders
        @orders = Kaminari.paginate_array(@all_orders).page(params[:page]).per(10)
      end
    else
      if search_params[:q].present?
        @all_orders = Order.where(event_id: @event)
        @search_order = @all_orders.search_order(search_params[:q])
        @orders = Kaminari.paginate_array(@search_order).page(params[:page]).per(10)
      else
        @all_orders = Order.where(event_id: @event)
        @orders = Kaminari.paginate_array(@all_orders).page(params[:page]).per(10)
      end
    end

    @total = @all_orders.approved.present? ? @all_orders.approved.sum(&:subtotal).format : "R$0,00"
    @total_pending = @all_orders.pending.present? ? @all_orders.pending.sum(&:subtotal).format : "R$0,00"

    respond_to do |format|
      format.html
      format.csv { send_data @orders.to_csv, filename: "orders-#{Date.today}.csv" }
    end
  end

  def manage_company
    @user = current_user
    if @user.update(company_id: params[:company_id])
      redirect_to backstage_path, notice: "Gerenciando #{Company.find(params[:company_id]).name}"
    else
      redirect_to backoffice_path, alert: "Ops... algo deu errado! Tente novamente."
    end
  end

  def check_in
    @events = Event.where(company_id: current_user.company_id).order(start_t: :desc).to_happen(8)
  end

  private

    def search_params
      params.permit(:q)
    end

end