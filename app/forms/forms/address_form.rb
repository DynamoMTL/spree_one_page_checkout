module Forms
  class AddressForm < Reform::Form
    model :address

    properties %w(
      firstname
      lastname
      address1
      city
      state_name
      country_id
      zipcode
      phone
      user_id
    )

    validates :firstname, :lastname, :address1,
      :city, :country_id, :zipcode, :phone, presence: true

    if ::Spree::Config[:address_requires_state]
      validates :state_name, presence: true
    end
  end
end
