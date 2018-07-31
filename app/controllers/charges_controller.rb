class ChargesController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]

  def new
  end

  def create
    # Amount in cents
    @amount = 500

    begin
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
      
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )

      flash['notice'] = "You successfully paid " + (@amount / 100).to_s
    rescue Stripe::CardError => e
      flash[:alert] = e.message
    rescue Stripe::InvalidRequestError => e
      flash[:alert] = e.message
    end
    redirect_back fallback_location: root_path
  end

  def subscriptions
    @plans = Plan.all
  end

  def subscribe
    plan = Plan.find(params[:plan_id])
    user = current_user
    begin
      if not user.stripe_id
        customer = Stripe::Customer.create(source: params[:stripe_token], email: user.email)
        user.update(stripe_id: customer.id)
      end

      subscription = Stripe::Subscription.create(customer: user.stripe_id, items: [{plan: plan.stripe_id}])
      user.subscriptions.create(stripe_id: subscription.id, plan_id: plan.id)
      flash[:notice] = 'Successfully created a subscription'
    rescue Stripe::CardError => e
      flash[:alert] = e.message
    rescue Stripe::InvalidRequestError => e
      flash[:alert] = e.message
    end
    redirect_back fallback_location: root_path
  end

  def unsubscribe
    subscription = current_user.subscriptions.first
    throw :abort unless subscription
    begin
      sub = Stripe::Subscription.retrieve(subscription.stripe_id)
      sub.delete
      subscription.destroy
      flash[:notice] = 'You successfully canceled your subscription'
    rescue Stripe::CardError => e
      flash[:alert] = e.message
    rescue Stripe::InvalidRequestError => e
      flash[:alert] = e.message
    end
    redirect_back fallback_location: root_path
  end

end
