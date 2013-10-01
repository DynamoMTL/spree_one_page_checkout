class CreatePayment
  def initialize(payment_factory, payment_method)
    @payment_factory = payment_factory
    @payment_method = payment_method
  end

  def call(total, source)
    payment_factory.create do |payment|
      payment.amount = total
      payment.payment_method = payment_method
      payment.source = source
    end
  end

  private

  attr_reader :payment_factory, :payment_method
end
