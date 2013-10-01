class AddUserIdToCreditCards < ActiveRecord::Migration
  def change
    change_table Spree::CreditCard.table_name do |t|
      t.references :user
    end
  end
end
