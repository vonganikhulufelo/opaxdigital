class PurchaseOrdersController < ApplicationController
  before_action :require_login
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  def index
    @purchases = PurchaseOrder.where(user_id: current_user.user_id).search(params[:search]).paginate(page: params[:page], per_page: 50).order('vendor_name ASC')
  end

  def new
    @purchase_order = PurchaseOrder.new
    @purchase_order.purchase_order_products.build 
    @suppliers = Supplier.where(user_id: current_user.user_id)
    
  end

  def create
    @purchase_order = PurchaseOrder.new(supplier_rebate_params)
      if @purchase_order.save
        @supplier = Supplier.find(@purchase_order.vendor_id)
        @payment = SupplierPaymentTerm.find(@purchase_order.payment_id)
        @zone = SPayMDistrict.find(@purchase_order.zone_id)
        @purchase_order.update(status: '1',vendor_name: @supplier.supplier_name,vendor_payment: @payment.payment_term_description, zone: @zone.magisterialdistrict_zone + ' ' +@zone.magisterialdistrict_district,system__internal_reference: @purchase_order.created_at.strftime("%Y%m%d%H%M%S"),order_date: @purchase_order.created_at)
        redirect_to purchase_orders_path
      end
  end

  def step2
    @purchase_order = PurchaseOrder.find_by(id: params[:id], user_id: current_user.user_id)
  end

  def step22
    @purchase_order = PurchaseOrder.find_by(id: params[:id], user_id: current_user.user_id)
    if @purchase_order.update(vendor_reference: params[:vendor_reference],vendor_documentation: params[:vendor_documentation], status: params[:status])
      redirect_to @purchase_order
    end
  end



  def step3
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def step33
    @purchase_order = PurchaseOrder.find(params[:id])

    @purchase_order_products = PurchaseOrderProduct.where(purchase_order_id: @purchase_order.id)


    if @purchase_order.update(step3_params)
      @purchase_order_products.each do | product |
        @tank = Tank.where(product_description: product.product_id)
        if @tank.each do | tank|

          tank.update(current_stock: (tank.current_stock + product.pick_up_quantity))
        end
      end
      end
      redirect_to @purchase_order
      
    end
  end

  def step4
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def edit
    @purchase_order = PurchaseOrder.find(params[:id])
    @suppliers = Supplier.where(user_id: current_user.user_id)
  end

  def update
    if @purchase_order.update(supplier_rebate_params)
      redirect_to @purchase_order
    end
  end

  def show
    @purchase = PurchaseOrder.find_by(id: params[:id], user_id: current_user.user_id)
  end

  def destroy
    @purchase = PurchaseOrder.find_by(id: params[:id], user_id: current_user.user_id)
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchase_orders_path, notice: 'Purchase order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_supplier
    @purchase_order = PurchaseOrder.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def supplier_rebate_params
    params.require(:purchase_order).permit(:purchase_user_id,:bol_reference,:vendor_name,:status, :recon_status,:vendor_payment,:zone,:zone_id,:payment_id,:vendor_id,:user_id,:order_date,:system__internal_reference,:internal_po_reference, purchase_order_products_attributes: PurchaseOrderProduct.attribute_names.map(&:to_sym).push(:_destroy) )
  end

  def step3_params
    params.require(:purchase_order).permit(:bol_reference,:vendor_name,:status, purchase_order_products_attributes: PurchaseOrderProduct.attribute_names.map(&:to_sym).push(:_destroy) )
  end

  def step4_params
    params.require(:purchase_order).permit(:recon_status)
  end
end