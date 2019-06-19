class SupplierRebatesController < ApplicationController
  before_action :require_login
  #before_action :set_supplier_rebate, only: [:show, :edit, :update, :destroy]

  # GET /supplier_rebates
  # GET /supplier_rebates.json
  def index
    if params[:search]
      @suppliers = Supplier.where('LOWER(supplier_name) LIKE ?', "%#{params[:search].downcase}%").paginate(page: params[:page], per_page: 30)
    else
      @suppliers = Supplier.order('supplier_name ASC').paginate(page: params[:page], per_page: 30)
    end
  end

  # GET /supplier_rebates/1
  # GET /supplier_rebates/1.json
  def show
    @suppliers = Supplier.where(user_id: current_user.user_id)
    @payment_terms = PaymentTerm.where(user_id: current_user.user_id)
    @magisterial_districts = MagisterialDistrict.where(user_id: current_user.user_id).order("zonedistrict ASC")
    @product_descriptions = ProductDescription.where(user_id: current_user.user_id)
    

    if params[:product_id] != 'n'
      @product = SPayMProductPrice.find(params[:product_id])
      @product_price = ProductPrice.find(@product.product_price_id)
      @product_description = ProductDescription.find(@product_price.product_description_id)
      @product_id = @product_description.id
    end
  end

  # GET /supplier_rebates/new
  def new
  
  end

  # GET /supplier_rebates/1/edit
  def edit
  end

  def zone
    @md = MagisterialDistrict.find(params[:MagisterialDistrict_Zone])
    SPayMDistrict.create(MagisterialDistrict_Zone: @md.MagisterialDistrict_Zone , MagisterialDistrict_District: params[:MagisterialDistrict_District] ,supplier_payment_term_id: params[:supplier_payment_term_id],magisterial_district_id: @md.id)
    redirect_to supplier_rebates_path
  end

  def payment
    params[:PaymentTerm_Description].each do | payment |
      @pt = PaymentTerm.find(payment)
      @pay = SupplierPaymentTerm.find_by(payment_term_id: payment, supplier_id: params[:supplier_id])
      if !@pay
        SupplierPaymentTerm.create(payment_term_description: @pt.PaymentTerm_Description, supplier_id: params[:supplier_id], payment_term_id: payment)
      end
    end
    #@pd = PaymentTerm.find(params[:PaymentTerm_Description])

    #SupplierPaymentTerm.create(payment_term_description: @pd.PaymentTerm_Description, supplier_id: params[:supplier_id], payment_term_id: params[:PaymentTerm_Description])
    redirect_to supplier_rebates_path
  end

  def rebate
    @supplier = Supplier.find(params[:supplier_id])
    @payment_term = PaymentTerm.find(params[:payment_term_id])
    @spayment_term = @supplier.supplier_payment_terms.find_by(payment_term_id: @payment_term.id)
    @magisterial_district = MagisterialDistrict.find(params[:magistrial_district_id])
    @zone = Zone.find_by(zone_description: @magisterial_district.magisterialdistrict_zone)
    @product_discription = ProductDescription.find(params[:product_discription_id])
    @product_price = ProductPrice.find_by(product_description_id: @product_discription.id, zone_id: @zone.id)

    if params[:product_id] != 'n'
      @s_pay_m_product_price = SPayMProductPrice.find(params[:product_id])
      @s_pay_m_product_price.update(claw_margin: params[:claw_margin],product_rebate: params[:rebate], net_price: params[:net_price])
      @s_pay_m_product_price1 = SPayMProductPrice.find(params[:product_id])
      @description = @s_pay_m_product_price1.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @s_pay_m_product_price.product_pescription_product.to_s + "$" + @s_pay_m_product_price.product_price_price.to_s + "$" + @s_pay_m_product_price1.product_rebate.to_s + "$"+ @s_pay_m_product_price1.claw_margin.to_s + "$" + @s_pay_m_product_price1.net_price.to_s
      Log.create!(user_id: current_user.user_id,description: @description, username: current_user.name, uid: @s_pay_m_product_price.uid.to_s)

         @customer_price = CPayMProductPrice.where(s_pay_m_product_price_id: @s_pay_m_product_price.id)

          if @customer_price.present?
            @customer_price.each do | customer |
              @supp_price = SPayMProductPrice.find(customer.s_pay_m_product_price_id)
              @gross = customer.net_price - @supp_price.net_price
              customer.update(s_net_price: @supp_price.net_price,gross_price: @gross,net_price: customer.net_price,product_price_price: customer.product_price_price)
              @customer_rebate = CPayMProductPrice.find(customer.id)
              @description1 = @customer_rebate.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @customer_rebate.product_pescription_product.to_s + "$" + @customer_rebate.product_price_price.to_s+ "$" + @customer_rebate.product_rebate.to_s + "$" + @customer_rebate.claw_margin.to_s + "$" + @customer_rebate.net_price.to_s + "$" + @customer_rebate.s_name.to_s + "$" + @customer_rebate.s_net_price.to_s + "$" + @customer_rebate.gross_price.to_s
              Log.create!(user_id: current_user.user_id,description: @description1, username: current_user.name, uid: customer.uid.to_s)
            end
          end
    else
      @district = SPayMDistrict.find_by(magisterial_district_id: params[:magistrial_district_id], supplier_payment_term_id: @spayment_term.id)
      if @district.present?
        @s_pay_m_product_price = SPayMProductPrice.find_by(s_pay_m_district_id: @district.id,product_description_id: @product_discription.id)
        if @s_pay_m_product_price
          @s_pay_m_product_price.update(claw_margin: params[:claw_margin],product_price_price: params[:product_price],product_rebate: params[:rebate], net_price: params[:net_price])
          @description = @s_pay_m_product_price.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @s_pay_m_product_price. product_pescription_product.to_s + "$" + @s_pay_m_product_price.product_price_price.to_s + "$" + @s_pay_m_product_price.product_rebate.to_s + "$" + @s_pay_m_product_price.claw_margin.to_s + "$" + @s_pay_m_product_price.net_price.to_s
          Log.create!(user_id: current_user.user_id,description: @description, username: current_user.name, uid: @s_pay_m_product_price.uid.to_s)
        else
        @s_pay_m_product_price2 = SPayMProductPrice.create!(claw_margin: params[:claw_margin],product_description_id: @product_discription.id,s_pay_m_district_id: @district.id,product_price_price: params[:product_price], product_pescription_product: @product_discription.productdescription_product,product_rebate: params[:rebate], net_price: params[:net_price] ,product_price_id: @product_price.id)
        @s_pay_m_product_price2.update(uid: 'rb_' + @s_pay_m_product_price2.id.to_s)
        @description2 = @s_pay_m_product_price2.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @s_pay_m_product_price2. product_pescription_product.to_s + "$" + @s_pay_m_product_price2.product_price_price.to_s + "$" + @s_pay_m_product_price2.product_rebate.to_s + "$" + @s_pay_m_product_price2.claw_margin.to_s + "$" + @s_pay_m_product_price2.net_price.to_s
        Log.create!(user_id: current_user.user_id,description: @description2, username: current_user.name, uid: 'rb_' + @s_pay_m_product_price2.id.to_s)
        end
      else
        @s_pay_m_district = SPayMDistrict.create!(magisterialdistrict_zone: @magisterial_district.magisterialdistrict_zone, magisterialdistrict_district: @magisterial_district.magisterialdistrict_district ,magisterial_district_id: @magisterial_district.id, supplier_payment_term_id: @spayment_term.id )
        @s_pay_m_product_price = SPayMProductPrice.create!(claw_margin: params[:claw_margin],product_description_id: @product_discription.id,s_pay_m_district_id: @s_pay_m_district.id,product_price_price: params[:product_price], product_pescription_product: @product_discription.productdescription_product,product_rebate: params[:rebate], net_price: params[:net_price] ,product_price_id: @product_price.id)
        @s_pay_m_product_price.update(uid: 'rb_' + @s_pay_m_product_price.id.to_s)
        @description = @s_pay_m_product_price.created_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @s_pay_m_product_price. product_pescription_product.to_s  + "$" + @s_pay_m_product_price.product_price_price.to_s + "$" + @s_pay_m_product_price.product_rebate.to_s + "$" + @s_pay_m_product_price.claw_margin.to_s + "$" + @s_pay_m_product_price.net_price.to_s
        Log.create!(user_id: current_user.user_id,description: @description, username: current_user.name, uid: 'rb_' + @s_pay_m_product_price.id.to_s)
      end


    end


  redirect_to supplier_rebates_path
end

  # POST /supplier_rebates
  # POST /supplier_rebates.json
  def create
    @supplier_rebate = SupplierRebate.new(supplier_rebate_params)

    respond_to do |format|
      if @supplier_rebate.save
        format.html { redirect_to @supplier_rebate, notice: 'Supplier rebate was successfully created.' }
        format.json { render :show, status: :created, location: @supplier_rebate }
      else
        format.html { render :new }
        format.json { render json: @supplier_rebate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplier_rebates/1
  # PATCH/PUT /supplier_rebates/1.json
  def update
    respond_to do |format|
      if @supplier_rebate.update(supplier_rebate_params)
        format.html { redirect_to @supplier_rebate, notice: 'Supplier rebate was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier_rebate }
      else
        format.html { render :edit }
        format.json { render json: @supplier_rebate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplier_rebates/1
  # DELETE /supplier_rebates/1.json
  def destroy
    @supplier_rebate.destroy
    respond_to do |format|
      format.html { redirect_to supplier_rebates_url, notice: 'Supplier rebate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_product
    @product = SPayMProductPrice.find(params[:id])
    @product.destroy
    respond_to do |format|
      format.html { redirect_to supplier_rebates_url, notice: 'Product rebate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_zone
    @zone = SPayMDistrict.find(params[:id])
    @zone.destroy
    respond_to do |format|
      format.html { redirect_to supplier_rebates_url, notice: 'Product rebate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_rebate
      @supplier_rebate = SupplierRebate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_rebate_params
      params.require(:supplier_rebate).permit(:SupplierRebate_Rebate, :SupplierRebate_Net_Price, :supplier_id, :user_id, :product_price_id, :magisterial_district_id, :product_description_id)
    end
end
