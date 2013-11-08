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

  def wait_for_ajax
    counter = 0
    while page.evaluate_script("$.active").to_i > 0
      counter += 1
      sleep(0.1)
      raise "AJAX request took longer than 5 seconds." if counter >= 50
    end
  end
end

RSpec.configure { |c| c.include IntegrationMacros, type: :feature }
