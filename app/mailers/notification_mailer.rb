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
    mail(to: @order.user.email, subject: "Pedido confirmado - #{@order.event.name}!")
  end

  def order_ticket
    @order = params[:order]
    @ticket_token = params[:ticket]
    attachments["#{@ticket_token.owner_name}-#{@ticket_token.event.name}-PartiuIngresso.pdf"] = VoucherPdfDiscreet.new(@ticket_token).render
    mail(to: @ticket_token.owner_email, subject: "Seu ingresso - #{@order.event.name}!")
  end

  def legacy_tickets
    @order = params[:order]
    @order.ticket_tokens.each do |t|
      attachments["#{t.owner_name}-#{t.event.name}-PartiuIngresso.pdf"] = VoucherPdf.new(t).render
    end
    mail(to: @order.user.email, subject: "Ingresso(s) - #{@order.event.name}!")
  end
end
