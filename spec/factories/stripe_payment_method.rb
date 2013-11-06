FactoryGirl.define do
  factory :stripe_payment_method, class: Spree::Gateway::StripeGateway do
    name "Credit Card (Stripe Test)"
    environment 'test'

    after_create do |pm, evaluator|
      pm.set_preference(:login, ENV.fetch('STRIPE_SECRET_KEY'))
      pm.set_preference(:server, 'test')
      pm.set_preference(:test_mode, 1)
    end
  end
end
