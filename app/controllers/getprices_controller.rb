class GetpricesController < ApplicationController
  skip_before_action :require_login
  def pricing
    
    @magisterial_district = MagisterialDistrict.find(params[:id])
    @zone = Zone.find_by(zone_description: @magisterial_district.magisterialdistrict_zone)
    @product_discription = ProductDescription.find(params[:product_id])
    @product_price = ProductPrice.find_by(product_description_id: @product_discription.id, zone_id: @zone.id)
    #@pp = @magisterial_district.s_pay_m_product_prices.find_by(product_price_id: @product_price.id)
    if(@product_price)
      @product_price1 = ProductPrice.find_by(product_description_id: @product_discription.id)
      @supplier = Supplier.joins(supplier_payment_terms: [{ s_pay_m_districts: :s_pay_m_product_prices }])
    .select('s_pay_m_districts.magisterialdistrict_zone as zone,s_pay_m_districts.magisterialdistrict_district as distirct, suppliers.supplier_name as name,supplier_payment_terms.payment_term_description as payment,s_pay_m_product_prices.id as product_id, suppliers.id as supplier_id, s_pay_m_product_prices.net_price as net_price')
    .where('s_pay_m_product_prices.product_description_id = ? ',@product_discription.id)
    .group('suppliers.id,s_pay_m_districts.magisterialdistrict_district, s_pay_m_product_prices.net_price,suppliers.supplier_name,supplier_payment_terms.payment_term_description,s_pay_m_product_prices.id,s_pay_m_districts.magisterialdistrict_zone')
      render json: {price: @product_price.productprice_price, supplier: @supplier}
      else
        render json: {error: "Not exist"}
      end

  end
end