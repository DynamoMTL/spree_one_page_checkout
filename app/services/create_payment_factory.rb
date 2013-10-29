class CreatePaymentFactory
  def self.build(order, *args)
    new(order).build(*args)
  end

  def initialize(order)
    @order = order
  end

  def build
    return create_payment
  end

  private

  attr_reader :order

  def create_payment
    @_create_payment ||= CreatePayment.new(payment_factory, payment_method)
  end

  def payment_factory
    @_payment_factory ||= order.payments
  end

  def payment_method
    Spree::PaymentMethod.available(:front_end).first
  end
end
