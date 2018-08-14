class StripeService

  class Error < StandardError; end
  
  def simpleCharge (token: nil, amount: 500, currency: 'usd', email: nil)
    begin
      customer = Stripe::Customer.create(
        :email => email,
        :source  => token
      )
      
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => amount,
        :description => 'Rails Stripe customer',
        :currency    => currency
      )
    rescue Stripe::StripeError => e
      Rails.logger.error 'Stripe::StripeError: ' + e.message
      raise Error.new e.message
    end
  end

  def subscribe (token: nil, user: nil, plan: nil)
    begin
      # Create stripe user if needed
      if not user.stripe_id
        customer = Stripe::Customer.create(source: token, email: user.email)
        user.update(stripe_id: customer.id)
      end

      subscription = Stripe::Subscription.create(customer: user.stripe_id, items: [{plan: plan.stripe_id}])
      user.subscriptions.create(stripe_id: subscription.id, plan_id: plan.id)
    rescue Stripe::StripeError => e
      Rails.logger.error 'Stripe::StripeError: ' + e.message
      raise Error.new e.message
    end
  end

  def unsubscribe (subscription)
    begin
      sub = Stripe::Subscription.retrieve(subscription.stripe_id)
      sub.delete
      subscription.destroy
    rescue Stripe::StripeError => e
      Rails.logger.error 'Stripe::StripeError: ' + e.message
      raise Error.new e.message
    end
  end

  def webhook (id)
    begin
      event = Stripe::Event.retrieve(id)
      
      # Delete subscriptions if it's cancelled
      if ['customer.subscription.deleted'].include? event.type
        subsc = Subscription.where(stripe_id: event.data.object.id).first
        subsc.delete if subsc
      end

    rescue Stripe::StripeError => e
      Rails.logger.error 'Stripe::StripeError: ' + e.message
      raise Error.new e.message
    end
  end
  
end
