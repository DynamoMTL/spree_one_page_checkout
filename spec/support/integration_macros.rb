module IntegrationMacros
  def configure_store
    create(:bogus_payment_method)

    # Require a country to be created so the shipping method creates the Global
    # Zone with the same country as orders' billing and shipping addresses.
    create(:country)
  end

  def configure_store_with_stripe
    create(:stripe_payment_method)

    # Require a country to be created so the shipping method creates the Global
    # Zone with the same country as orders' billing and shipping addresses.
    create(:country)
  end
end

RSpec.configure { |c| c.include IntegrationMacros, type: :feature }
