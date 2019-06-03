class CustomerRebatesController < ApplicationController
  before_action :require_login
  #before_action :set_customer_rebate, only: [:show, :edit, :update, :destroy]

  # GET /customer_rebates
  # GET /customer_rebates.json
  def index
   @customers = Customer.order('customer_name ASC')
  end

  # GET /customer_rebates/1
  # GET /customer_rebates/1.json
  def show
    @supplier = Supplier.where(user_id: current_user.user_id)
    @payment_term = PaymentTerm.find(params[:payment_id])
    @customer = Customer.find(params[:cutomer_id])
    @magisterial_districts = MagisterialDistrict.where(user_id: current_user.user_id).order("zonedistrict ASC")
    if params[:zone_id] != 'n'
      @magisterial_district = MagisterialDistrict.find(params[:zone_id])
    end
    @product_descriptions = ProductDescription.where(user_id: current_user.user_id)
    
    if params[:id] != 'n'
      @product = CPayMProductPrice.find(params[:id])
      @product_description = ProductDescription.find(params[:product_id])
      @supplier_value = @product.supplier_id.to_s + '/' + + @product.id.to_s + "/" + @product.s_zone.to_s
      @supplier_text = @product.s_name.to_s + ' ' + @product.s_payment.to_s + " " + @product.s_net_price.to_s + " " + @product.s_zone.to_s

    end

  end

  def crebate
      @customer = Customer.find(params[:customer_id])
      @supplier_price = SPayMProductPrice.find(params[:supplier_id].split("/")[1]) 
      @supplier= Supplier.find(params[:supplier_id].split("/")[0])
      @payment_term = PaymentTerm.find(params[:payment_term_id])
      @spayment_term = @customer.customer_payment_terms.find_by(payment_term_id: @payment_term.id)
      @magisterial_district = MagisterialDistrict.find(params[:magistrial_district_id])
      @zone = Zone.find_by(zone_description: @magisterial_district.magisterialdistrict_zone)
      @product_discription = ProductDescription.find(params[:product_discription_id])
      @product_price = ProductPrice.find_by(product_description_id: @product_discription.id, zone_id: @zone.id)
      @gross_price = params[:net_price].to_d - @supplier_price.net_price.to_d
      
      @district = CPayMDistrict.find_by(magisterial_district_id: params[:magistrial_district_id], customer_payment_term_id: @spayment_term.id)
      
      if @district.present?
        @c_pay_m_product_price1 = CPayMProductPrice.find_by(c_pay_m_district_id: @district.id, product_description_id: @product_discription.id)
        if @c_pay_m_product_price1
          @c_pay_m_product_price1.update(claw_margin: params[:claw_margin],product_price_price: params[:product_price],product_rebate: params[:rebate], net_price: params[:net_price],supplier_id: @supplier.id,s_name: @supplier.supplier_name, s_net_price: @supplier_price.net_price, gross_price: @gross_price)
          @p = CPayMProductPrice.find(@c_pay_m_product_price1.id)
          @description2 = @p.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @c_pay_m_product_price1.product_pescription_product.to_s + "$" + params[:product_price].to_s+ "$" + params[:rebate].to_s + "$" + params[:claw_margin].to_s + "$" + params[:net_price] + "$" + @supplier.supplier_name.to_s + "$" + @supplier_price.net_price.to_s + "$" + @gross_price.to_s
          Log.create!(user_id: current_user.user_id,description: @description2, username: current_user.name, uid: 'rb_' + @c_pay_m_product_price1.id.to_s)
        else
        @c_pay_m_product_price = CPayMProductPrice.create!(claw_margin: params[:claw_margin],s_pay_m_product_price_id: @supplier_price.id,product_description_id: @product_discription.id,c_pay_m_district_id: @district.id,product_price_price: params[:product_price], product_pescription_product: @product_discription.productdescription_product,product_rebate: params[:rebate], net_price: params[:net_price] ,product_price_id: @product_price.id,supplier_id: @supplier.id,s_name: @supplier.supplier_name, s_net_price: @supplier_price.net_price, gross_price: @gross_price)
        @c_pay_m_product_price.update(uid: 'rb_' + @c_pay_m_product_price.id.to_s)
        @description = @c_pay_m_product_price.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @c_pay_m_product_price.product_pescription_product.to_s + "$" + params[:product_price].to_s+ "$" + params[:rebate].to_s + "$" + params[:claw_margin].to_s + "$" + params[:net_price] + "$" + @supplier.supplier_name.to_s + "$" + @supplier_price.net_price.to_s + "$" + @gross_price.to_s
        Log.create!(user_id: current_user.user_id,description: @description, username: current_user.name, uid: 'rb_' + @c_pay_m_product_price.id.to_s)
        end
      else
        @c_pay_m_district = CPayMDistrict.create!(magisterialdistrict_zone: @magisterial_district.magisterialdistrict_zone, magisterialdistrict_district: @magisterial_district.magisterialdistrict_district ,magisterial_district_id: @magisterial_district.id, customer_payment_term_id: @spayment_term.id )
        @c_pay_m_product_price = CPayMProductPrice.create!(claw_margin: params[:claw_margin],s_pay_m_product_price_id: @supplier_price.id,product_description_id: @product_discription.id,c_pay_m_district_id: @c_pay_m_district.id,product_price_price: params[:product_price], product_pescription_product: @product_discription.productdescription_product,product_rebate: params[:rebate], net_price: params[:net_price] ,product_price_id: @product_price.id,supplier_id: @supplier.id,s_name: @supplier.supplier_name, s_net_price: @supplier_price.net_price, gross_price: @gross_price)
        @c_pay_m_product_price.update(uid: 'rb_' + @c_pay_m_product_price.id.to_s)
        @description1 = @c_pay_m_product_price.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @c_pay_m_product_price.product_pescription_product.to_s + "$" + params[:product_price].to_s+ "$" + params[:rebate].to_s + "$" + params[:claw_margin].to_s + "$" + params[:net_price] + "$" + @supplier.supplier_name.to_s + "$" + @supplier_price.net_price.to_s + "$" + @gross_price.to_s
        Log.create!(user_id: current_user.user_id, description: @description1, username: current_user.name, uid: 'rb_' + @c_pay_m_product_price.id.to_s)
      end
    redirect_to customer_rebates_path
  end

  # GET /customer_rebates/new
  def new
    @customer_rebate = CustomerRebate.new
  end

  # GET /customer_rebates/1/edit
  def edit
  end

  # POST /customer_rebates
  # POST /customer_rebates.json
  def create
    @customer_rebate = CustomerRebate.new(customer_rebate_params)

    respond_to do |format|
      if @customer_rebate.save
        format.html { redirect_to @customer_rebate, notice: 'Customer rebate was successfully created.' }
        format.json { render :show, status: :created, location: @customer_rebate }
      else
        format.html { render :new }
        format.json { render json: @customer_rebate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_rebates/1
  # PATCH/PUT /customer_rebates/1.json
  def update
    respond_to do |format|
      if @customer_rebate.update(customer_rebate_params)
        format.html { redirect_to @customer_rebate, notice: 'Customer rebate was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer_rebate }
      else
        format.html { render :edit }
        format.json { render json: @customer_rebate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_rebates/1
  # DELETE /customer_rebates/1.json
  def destroy
    @customer_rebate.destroy
    respond_to do |format|
      format.html { redirect_to customer_rebates_url, notice: 'Customer rebate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_product
    @product = CPayMProductPrice.find(params[:id])
    @product.destroy
    respond_to do |format|
      format.html { redirect_to customer_rebates_url, notice: 'Product rebate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_zone
    @zone = CPayMDistrict.find(params[:id])
    @zone.destroy
    respond_to do |format|
      format.html { redirect_to customer_rebates_url, notice: 'Zone rebate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_rebate
      @customer_rebate = CustomerRebate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_rebate_params
      params.require(:customer_rebate).permit(:CustomerRebates_Rebate, :CustomerRebates_Net_Price, :customer_id, :user_id, :product_price_id, :magisterial_district_id, :product_description_id)
    end
end
