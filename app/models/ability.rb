class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new(role: "guest")

    can :show, Event
    can [:create, :success], Order

    unless user.guest?
        can :read, TicketToken do |ticket_token|
            ticket_token.user == user
        end
        can [:read, :create, :success], Order, user_id: user.id
    end

    unless user.guest? || user.user?
        can [:new_validation, :create_validation], TicketToken do |ticket_token|
            ticket_token.event.company == user.company
        end
    end

    if user.admin?
        can :manage, Company
        can :manage, Event, company_id: user.company_id
        can :manage, CompanyFinance, company_id: user.company_id
        can :manage, :admin
        can :manage, Transfer
        can :manage, TicketToken
        can [:send_received_email, :send_confirmed_email, :send_ticket_email, :send_legacy_email, 
             :send_refunded_email, :send_denied_email], Order
    end

    if user.producer_admin?
        can :producer_admin, :admin
        can :report, :admin
        can :check_in, :admin
        can :manage, Company, id: user.company_id
        can :manage, CompanyFinance, company_id: user.company_id
        can [:read, :edit], Event, company_id: user.company_id
        can [:read, :create], Transfer, company_id: user.company_id
    end

    if user.producer?
        can :check_in, :admin
        can :read, Event, company_id: user.company_id
    end

    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
