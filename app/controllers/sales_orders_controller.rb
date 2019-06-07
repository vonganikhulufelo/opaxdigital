class SalesOrdersController < ApplicationController
  def index
    @sales = SalesOrder.where(user_id: current_user.user_id)
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

  def customer_rebate_params
    params.require(:sales_order).permit(:user_id,:order_date,:customer_id, :recon, :zone_id,:payment_id,:customer_id,:invoice,:puma_reference,:delivery_note_reference,:delivery_attachment,:status,:delivery_date_on_delivery, sales_order_products_attributes: SalesOrderProduct.attribute_names.map(&:to_sym).push(:_destroy) )
  end
end