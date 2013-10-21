class AddUserIdToAddresses < ActiveRecord::Migration
  def change
    add_column table_name, :user_id, :integer
  end

  def migrate(direction)
    super unless direction == :up && column_exists?(table_name, :user_id)
  end

  private

  def table_name
    Spree::Address.table_name
  end
end
