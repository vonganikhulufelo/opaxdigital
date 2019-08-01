class DashboardsController < ApplicationController
	def dashboard
		@suppliers = Supplier.all
		@customers = Customer.all
		@purchases = PurchaseOrder.all
		@sales = SalesOrder.all
		@product_prices = ProductPrice.where(user_id: current_user.user_id).search(params[:search]).paginate(page: params[:page], per_page: 10).order('updated_at DESC')
	end
end