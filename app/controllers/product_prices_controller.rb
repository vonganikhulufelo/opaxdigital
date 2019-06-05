class ProductPricesController < ApplicationController
  before_action :require_login
  before_action :set_product_price, only: [:show, :edit, :update, :destroy]

  # GET $product_prices
  # GET $product_prices.json
  def index
    @product_prices = ProductPrice.where(user_id: current_user.user_id).order("updated_at ASC")
  end

  # GET $product_prices$1
  # GET $product_prices$1.json
  def show
  end

  # GET $product_prices$new
  def new
    @product_price = ProductPrice.new
  end

  # GET $product_prices$1$edit
  def edit
  end



def import
  CSV.foreach(params[:file].path, headers: true) do |row|

     if row[1].length < 3
        @zonename = '0' + row[1]
     else
      @zonename = row[1]
     end
    @zone = Zone.find_by(zone_description: @zonename)
    @product_description = ProductDescription.find_by(productdescription_product: row[2])

    if @zone.present?
      if @product_description.present?
        @product_price = ProductPrice.find_by(product_description_id: @product_description.id, zone_id: @zone.id)
        if !@product_price.present?
          @ppp = ProductPrice.create!(user_id: current_user.user_id,productprice_month_id: row[0], productprice_zone_class: @zone.zone_description,productdescription_product: row[2],productprice_price: row[3], zone_id: @zone.id, product_description_id: @product_description.id)
          @uuip =  @ppp.update(uid: 'pp_' + @ppp.id.to_s)
          @dis = row[0].to_s + '$' + row[1].to_s + '$' + row[2].to_s + '$' + row[3].to_s
          
          Log.create!(description: @dis, username: current_user.name, uid: @ppp.uid.to_s,user_id: current_user.user_id)
        else
          @dis12 = row[0].to_s + '$' + row[1].to_s + '$' + row[2].to_s + '$' + row[3].to_s
          @log = Log.find_by(description: @dis12)

          if !@log.present?
         @product_price.update(productprice_price: row[3])
         @dis = row[0].to_s + '$' + row[1].to_s + '$' + row[2].to_s + '$' + row[3].to_s
          Log.create!(description: @dis, username: current_user.name, uid: @product_price.uid.to_s,user_id: current_user.user_id)
         @product_price1 = ProductPrice.find(@product_price.id)

         @supplier_price = SPayMProductPrice.where(product_price_id: @product_price1.id)
         @customer_price = CPayMProductPrice.where(product_price_id: @product_price1.id)
          
          if @supplier_price.present?
            @supplier_price.each do | supplier |
              supplier.update(net_price: @product_price1.productprice_price + supplier.product_rebate,product_price_price: @product_price1.productprice_price)
              @net = @product_price1.productprice_price + supplier.product_rebate
                @s_pay_m_product_price1 = SPayMProductPrice.find(supplier.id)
                @description = @s_pay_m_product_price1.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @s_pay_m_product_price1.product_pescription_product.to_s + "$" + @s_pay_m_product_price1.product_price_price.to_s + "$" + @s_pay_m_product_price1.product_rebate.to_s + "$"+ @s_pay_m_product_price1.claw_margin.to_s + "$" + @s_pay_m_product_price1.net_price.to_s
                Log.create!(user_id: current_user.user_id,description: @description, username: current_user.name, uid: supplier.uid.to_s)
            end
          end

          if @customer_price.present?
            @customer_price.each do | customer |
              @supp_price = SPayMProductPrice.find(customer.s_pay_m_product_price_id)
              @gross = (@product_price1.productprice_price + customer.product_rebate) - @supp_price.net_price
             @customer_rebate = CPayMProductPrice.find(customer.id)
              @description1 = @customer_rebate.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @customer_rebate.product_pescription_product.to_s + "$" + @customer_rebate.product_price_price.to_s+ "$" + @customer_rebate.product_rebate.to_s + "$" + @customer_rebate.claw_margin.to_s + "$" + @customer_rebate.net_price.to_s + "$" + @customer_rebate.s_name.to_s + "$" + @customer_rebate.s_net_price.to_s + "$" + @customer_rebate.gross_price.to_s
              Log.create!(user_id: current_user.user_id,description: @description1, username: current_user.name, uid: customer.uid.to_s)
            end
          end
        end
      end
      end
    end
  end
  redirect_to product_prices_url, notice: "Products imported."
end



  # POST $product_prices
  # POST $product_prices.json
  def create
   @check_product = ProductPrice.find_by(product_description_id: params[:product_description_id], zone_id: params[:zone_id])
    if !@check_product
      @product_description = ProductDescription.find(params[:product_discription_id])
      @zone = Zone.find(params[:zone_id])
      @product_price = ProductPrice.new(user_id: current_user.user_id,product_description_id: params[:product_discription_id], productprice_month_id: params[:month_id], zone_id: params[:zone_id], productprice_price: params[:productprice_price],productdescription_product: @product_description.productdescription_product,productprice_zone_class: @zone.zone_description)

      respond_to do |format|
        if @product_price.save
          @uid = @product_price.update(uid: 'pp_' + @product_price.id.to_s)
          @description = @product_price.productprice_month_id.to_s + '$' + @product_price.productprice_zone_class.to_s + '$' + @product_price.productdescription_product.to_s + '$' + @product_price.productprice_price.to_s
          Log.create!(user_id: current_user.user_id,description:@description, username: current_user.name, uid: 'pp_' + @product_price.id.to_s)
          format.html { redirect_to product_prices_url, notice: 'Product price was successfully created.' }
          format.json { render :show, status: :created, location: @product_price }
        else
          format.html { render :new }
          format.json { render json: @product_price.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        @product_description = ProductDescription.find(params[:product_discription_id])
        @zone = Zone.find(params[:zone_id])
  
        if @check_product.update(product_description_id: params[:product_discription_id], productprice_month_id: params[:month_id], zone_id: params[:zone_id], productprice_price: params[:productprice_price],productdescription_product: @product_description.productdescription_product,productprice_zone_class: @zone.zone_description)
          @description = params[:month_id] + '$' + @zone.zone_description + '$' + @product_description.productdescription_product.to_s + '$' + params[:productprice_price].to_s
          Log.create!(description:@description, username: current_user.name, uid: @check_product.uid,user_id: current_user.user_id)
          @product_price1 = ProductPrice.find(@check_product.id)
          @supplier_price = SPayMProductPrice.where(product_price_id: @check_product.id)
         @customer_price = CPayMProductPrice.where(product_price_id: @check_product.id)
          
          if @supplier_price.present?
            @supplier_price.each do | supplier |
              supplier.update(net_price: @product_price1.productprice_price + supplier.product_rebate,product_price_price: @product_price1.productprice_price)
              @net = @product_price1.productprice_price + supplier.product_rebate
              @s_pay_m_product_price1 = SPayMProductPrice.find(supplier.id)
                @description = @s_pay_m_product_price1.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @s_pay_m_product_price1.product_pescription_product.to_s + "$" + @s_pay_m_product_price1.product_price_price.to_s + "$" + @s_pay_m_product_price1.product_rebate.to_s + "$"+ @s_pay_m_product_price1.claw_margin.to_s + "$" + @s_pay_m_product_price1.net_price.to_s
                Log.create!(user_id: current_user.user_id,description: @description, username: current_user.name, uid: supplier.uid.to_s)
            end
          end

          if @customer_price.present?
            @customer_price.each do | customer |
              @supp_price = SPayMProductPrice.find(customer.s_pay_m_product_price_id)
              @gross = (@product_price1.productprice_price + customer.product_rebate) - @supp_price.net_price
              customer.update(s_net_price: @supp_price.net_price,gross_price: @gross,net_price: @product_price1.productprice_price + customer.product_rebate,product_price_price: @product_price1.productprice_price)
              @customer_rebate = CPayMProductPrice.find(customer.id)
              @description1 = @customer_rebate.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @customer_rebate.product_pescription_product.to_s + "$" + @customer_rebate.product_price_price.to_s+ "$" + @customer_rebate.product_rebate.to_s + "$" + @customer_rebate.claw_margin.to_s + "$" + @customer_rebate.net_price.to_s + "$" + @customer_rebate.s_name.to_s + "$" + @customer_rebate.s_net_price.to_s + "$" + @customer_rebate.gross_price.to_s
              Log.create!(user_id: current_user.user_id,description: @description1, username: current_user.name, uid: customer.uid.to_s)
            end
          end
          format.html { redirect_to product_prices_url, notice: 'Product price was successfully updated.' }
          format.json { render :show, status: :ok, location: @product_price }
        else
          format.html { render :edit }
          format.json { render json: @product_price.errors, status: :unprocessable_entity }
        end
      end
      redirect_to product_prices_url
    end
  end

  # PATCH$PUT $product_prices$1
  # PATCH$PUT $product_prices$1.json
  def update
    respond_to do |format|
      @product_description = ProductDescription.find(params[:product_discription_id])
      @zone = Zone.find(params[:zone_id])

      if @product_price.update(product_description_id: params[:product_discription_id], productprice_month_id: params[:month_id], zone_id: params[:zone_id], productprice_price: params[:productprice_price],productdescription_product: @product_description.productdescription_product,productprice_zone_class: @zone.zone_description)
        @description = params[:month_id] + '$' + @zone.zone_description + '$' + @product_description.productdescription_product.to_s + '$' + params[:productprice_price].to_s
         Log.create!(description:@description, username: current_user.name, uid: @product_price.uid,user_id: current_user.user_id)
         @product_price1 = ProductPrice.find(@product_price.id)
          @supplier_price = SPayMProductPrice.where(product_price_id: @product_price.id)
         @customer_price = CPayMProductPrice.where(product_price_id: @product_price.id)
          
          if @supplier_price.present?
            @supplier_price.each do | supplier |
              supplier.update(net_price: @product_price1.productprice_price + supplier.product_rebate,product_price_price: @product_price1.productprice_price)
              @net = @product_price1.productprice_price + supplier.product_rebate
              @s_pay_m_product_price1 = SPayMProductPrice.find(supplier.id)
                @description = @s_pay_m_product_price1.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @s_pay_m_product_price1.product_pescription_product.to_s + "$" + @s_pay_m_product_price1.product_price_price.to_s + "$" + @s_pay_m_product_price1.product_rebate.to_s + "$"+ @s_pay_m_product_price1.claw_margin.to_s + "$" + @s_pay_m_product_price1.net_price.to_s
                Log.create!(user_id: current_user.user_id,description: @description, username: current_user.name, uid: supplier.uid.to_s)
            end
          end

          if @customer_price.present?
            @customer_price.each do | customer |
              @supp_price = SPayMProductPrice.find(customer.s_pay_m_product_price_id)
              @gross = (@product_price1.productprice_price + customer.product_rebate) - @supp_price.net_price
              customer.update(s_net_price: @supp_price.net_price,gross_price: @gross,net_price: @product_price1.productprice_price + customer.product_rebate,product_price_price: @product_price1.productprice_price)
              @customer_rebate = CPayMProductPrice.find(customer.id)
              @description1 = @customer_rebate.updated_at.strftime("%Y-%m-%d %H:%M:%S").to_s + "$" + @customer_rebate.product_pescription_product.to_s + "$" + @customer_rebate.product_price_price.to_s+ "$" + @customer_rebate.product_rebate.to_s + "$" + @customer_rebate.claw_margin.to_s + "$" + @customer_rebate.net_price.to_s + "$" + @customer_rebate.s_name.to_s + "$" + @customer_rebate.s_net_price.to_s + "$" + @customer_rebate.gross_price.to_s
              Log.create!(user_id: current_user.user_id,description: @description1, username: current_user.name, uid: customer.uid.to_s)
            end
          end
        format.html { redirect_to product_prices_url, notice: 'Product price was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_price }
      else
        format.html { render :edit }
        format.json { render json: @product_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE $product_prices$1
  # DELETE $product_prices$1.json
  def destroy
    @product_price.destroy
    respond_to do |format|
      format.html { redirect_to product_prices_url, notice: 'Product price was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_price
      @product_price = ProductPrice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_price_params
      params.require(:product_price).permit(:user_id, :productprice_month_id, :productprice_zone_class, :productprice_price, :zone_id, :product_description_id)
    end
end
