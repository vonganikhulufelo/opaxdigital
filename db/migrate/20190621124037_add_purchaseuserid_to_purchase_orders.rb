class AddPurchaseuseridToPurchaseOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :purchase_orders, :purchase_user_id, :bigint
  end
end
