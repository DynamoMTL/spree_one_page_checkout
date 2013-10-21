class AddUserIdToCreditCards < ActiveRecord::Migration
  def change
    add_column table_name, :user_id, :integer
  end

  private

  def table_name
    Spree::CreditCard.table_name
  end
end
