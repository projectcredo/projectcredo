class ChargesController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :webhook]
  skip_before_action :verify_authenticity_token, only: :webhook

  def new
  end

  def create
    amount = 500
    begin
      StripeService.new.simpleCharge(token: params[:stripeToken], amount: amount, email: params[:stripeEmail])
      flash['notice'] = 'You successfully paid $' + (amount / 100).to_s
    rescue StripeService::Error => e
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
      StripeService.new.subscribe(token: params[:stripe_token], user: user, plan: plan)
      flash[:notice] = 'Successfully created a subscription'
    rescue StripeService::Error => e
      flash[:alert] = e.message
    end
    redirect_back fallback_location: root_path
  end

  def unsubscribe
    subscription = current_user.subscriptions.first
    raise ActiveRecord::RecordNotFound.new('Subscripton not found') unless subscription
    begin
      StripeService.new.unsubscribe(subscription)
      flash[:notice] = 'You successfully canceled your subscription'
    rescue StripeService::Error => e
      flash[:alert] = e.message
    end
    redirect_back fallback_location: root_path
  end

  def webhook
    render text: 'id is required', status: 400 and return unless params.key?(:id)
    begin
      StripeService.new.webhook(params[:id])
      render nothing: true, status: 200
    rescue StripeService::Error => e
      render text: e.message, status: 400
    end
  end

end
