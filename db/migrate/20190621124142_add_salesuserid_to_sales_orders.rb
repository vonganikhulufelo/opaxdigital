class AddSalesuseridToSalesOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :sales_orders, :sales_user_id, :bigint
  end
end
