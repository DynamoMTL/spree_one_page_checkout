class AddUserIdToAddresses < ActiveRecord::Migration
  def change
    change_table Spree::Address.table_name do |t|
      t.references :user
    end
  end
end
