class NotificationMailer < ApplicationMailer
  def order_received
    @order = params[:order]
    mail(to: @order.user.email, subject: "Pedido recebido - #{@order.event.name}")
  end

  def order_confirmed
    @order = params[:order]
    @order.ticket_tokens.each do |t|
      attachments["#{t.owner_name}-#{t.event.name}-PartiuIngresso.pdf"] = VoucherPdf.new(t).render
    end
    mail(to: @order.user.email, subject: "Pedido confirmado - #{@order.event.name}")
  end

  def free_order_confirmed
    @order = params[:order]
    @order.ticket_tokens.each do |t|
      attachments["#{t.owner_name}-#{t.event.name}-PartiuIngresso.pdf"] = VoucherPdfDiscreet.new(t).render
    end
    mail(to: @order.user.email, subject: "Pedido confirmado - #{@order.event.name}")
  end

  def order_ticket
    @order = params[:order]
    @ticket_token = params[:ticket]
    attachments["#{@ticket_token.owner_name}-#{@ticket_token.event.name}-PartiuIngresso.pdf"] = VoucherPdfDiscreet.new(@ticket_token).render
    mail(to: @ticket_token.owner_email, subject: "Seu ingresso - #{@order.event.name}")
  end

  def order_not_paid
    @order = params[:order]
    mail(to: @order.user.email, subject: "Pedido não processado - #{@order.event.name}")
  end

  def order_reverted
    @order = params[:order]
    mail(to: @order.user.email, subject: "Pedido reembolsado - #{@order.event.name}")
  end

  def order_event_cancelled
    @order = params[:order]
    event = @order.event
    location = "#{event.address.city}/#{event.address.state.upcase}"
    date = event.start_t.strftime("%d/%m")
    subject = "Evento cancelado: #{event.name} - #{location} - #{date}"
    mail(to: @order.user.email, subject: subject)
  end

  def legacy_tickets
    @order = params[:order]
    @order.ticket_tokens.each do |t|
      attachments["#{t.owner_name}-#{t.event.name}-PartiuIngresso.pdf"] = VoucherPdfLegacy.new(t).render
    end
    mail(to: @order.ticket_tokens[0].owner_email, subject: "Ingresso(s) - #{@order.event.name}")
  end

  def legacy_confirmation
    @order = params[:order]
    @order.ticket_tokens.each do |t|
      attachments["#{t.owner_name}-#{t.event.name}-PartiuIngresso.pdf"] = VoucherPdfLegacy.new(t).render
    end
    mail(to: @order.ticket_tokens[0].owner_email, subject: "Confirmação de recebimento de ingresso(s)")
  end
end
