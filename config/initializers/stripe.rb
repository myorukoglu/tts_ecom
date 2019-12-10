Rails.configuration.stripe = {

  :publishable_key => "pk_test_zsVdos39PyNY1lUS3mDtzxia00wYWsqI0H",

  :secret_key => "sk_test_3lHwqXOPi2ZxLRAFYxrolMIf00pZccZVrw"

}

Stripe.api_key = Rails.configuration.stripe[:secret_key]