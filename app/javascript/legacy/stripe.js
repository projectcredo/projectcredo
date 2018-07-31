/*
 * Stripe subscriptions
 */
jQuery($ => {
  const $form = $('#subscribe_form')
  if (!$form.length || !global.StripeCheckout || !global.stripe) return

  const handler = StripeCheckout.configure({
    key: global.stripe.publishable_key,
    locale: 'auto',
    name: 'Project Credo',
    description: 'Create a Subscription',
    email: global.stripe.email,
    token: function(token) {
      $form.find('[name=stripe_token]').val(token.id)
      $form.submit()
    },
  })

  $('.subscription-button').on('click', function(e) {
    e.preventDefault()

    const plan = $(this).data('plan')
    $form.find('[name=plan_id]').val(plan.id)

    const amount = parseFloat(plan.price) * 100

    handler.open({
      description: `Subscribe to plan: ${plan.name}`,
      amount: Math.round(amount),
    })
  })
})
