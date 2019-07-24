class DashboardsController < ApplicationController
	def dashboard
		@suppliers = Supplier.all
		@customers = Customer.all
		@purchases = PurchaseOrder.all
		@sales = SalesOrder.all
		@product_prices = ProductPrice.where(user_id: current_user.user_id).search(params[:search]).paginate(page: params[:page], per_page: 10).order('updated_at DESC')
		
		@a = Daru::Vector.new([1,2,3,4,5], index: [:a, :b, :c, :d, :e], name: :bazinga)
	end
end