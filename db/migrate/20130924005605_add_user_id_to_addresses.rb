class AddUserIdToAddresses < ActiveRecord::Migration
  def change
    change_table table_name do |t|
      t.references :user
    end
  end

  def migrate(direction)
    super unless direction == :up && column_exists?(table_name, :user_id)
  end

  private

  def table_name
    Spree::Address.table_name
  end
end
