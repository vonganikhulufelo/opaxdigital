class SalesOrdersController < ApplicationController
  def index
    @sales = SalesOrder.where(user_id: current_user.user_id).search(params[:search]).paginate(page: params[:page], per_page: 50).order('customer_name ASC')
    @sales1 = sales_sql
  end

  def new
    @sales_order = SalesOrder.new
    @sales_order.sales_order_products.build 
    @customers = Customer.where(user_id: current_user.user_id)
  end

  def create
    @sales_order = SalesOrder.new(customer_rebate_params)
      if @sales_order.save
        @customer = Customer.find(@sales_order.customer_id)
        @payment = CustomerPaymentTerm.find(@sales_order.payment_id)
        @zone = CPayMDistrict.find(@sales_order.zone_id)
        @sales_order.update(status: '1',customer_name: @customer.customer_name,payment: @payment.payment_term_description, zone: @zone.magisterialdistrict_zone + ' ' +@zone.magisterialdistrict_district)
        redirect_to sales_orders_path
      end
  end

  def show
    @sales_order = SalesOrder.find_by(id: params[:id], user_id: current_user.user_id)
  end

  def edit
    @sales_order = SalesOrder.find_by(id: params[:id], user_id: current_user.user_id)
    @customers = Customer.where(user_id: current_user.user_id)
  end

  def step2
    @sales_order = SalesOrder.find_by(id: params[:id], user_id: current_user.user_id)
  end

  def step3
    @sales_order = SalesOrder.find_by(id: params[:id], user_id: current_user.user_id)
  end

  def step4
    @sales_order = SalesOrder.find_by(id: params[:id], user_id: current_user.user_id)
  end

  def update
    @sales_order = SalesOrder.find_by(id: params[:id], user_id: current_user.user_id)
    if @sales_order.update(customer_rebate_params)
      redirect_to @sales_order
    end
  end

  def destroy
    @sales_order = SalesOrder.find_by(id: params[:id], user_id: current_user.user_id)
    @sales_order.destroy
    respond_to do |format|
      format.html { redirect_to sales_orders_path, notice: 'Purchase order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def sales_sql
    ::User.find(current_user.user_id).sales_orders.joins(:sales_order_products).select('sales_orders.customer_name as customer_name, sales_orders.status as status, sales_orders.zone as zone, sales_orders.order_date as order_date, sales_orders.payment as payment, sales_orders.zone as zone, sales_orders.invoice as invoice, sales_orders.recon as recon, sales_orders.delivery_date_on_delivery as estimated_delivery_date,
      sales_order_products.product_name as product_name, sales_order_products.order_rate as order_rate, sales_order_products.order_quantity as order_quantity, sales_order_products.order_value as order_value, sales_order_products.delivered_date as product_delivered_date, sales_orders.id')
    .group('sales_orders.customer_name, sales_orders.status, sales_orders.zone, sales_orders.order_date, sales_orders.payment, sales_orders.zone, sales_orders.invoice, sales_orders.recon, sales_orders.delivery_date_on_delivery, sales_orders.delivery_date_on_delivery, sales_order_products.product_name, sales_order_products.order_rate, sales_order_products.order_quantity, sales_order_products.order_value, sales_order_products.delivered_date, sales_orders.id')
  end

  def customer_rebate_params
    params.require(:sales_order).permit(:sales_user_id,:user_id,:order_date,:customer_id, :recon, :zone_id,:payment_id,:customer_id,:invoice,:puma_reference,:delivery_note_reference,:delivery_attachment,:status,:delivery_date_on_delivery, sales_order_products_attributes: SalesOrderProduct.attribute_names.map(&:to_sym).push(:_destroy) )
  end
end