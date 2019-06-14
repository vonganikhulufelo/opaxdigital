class PriceLookupsController < ApplicationController
    def index
    	if params[:search]
    		pricelook.where('zonedistrict LIKE ?', "%#{params[:search]}%").paginate(page: params[:page], per_page: 30)
    	else
    		pricelook.paginate(page: params[:page], per_page: 30).order('zonedistrict ASC')
    	end
    end

    private

    def pricelook
    @price_lookups = current_user.zones.joins(:magisterial_districts, :product_prices).select('magisterial_districts.zonedistrict as zone_district, magisterial_districts.magisterialdistrict_code as magisterial_code, product_prices.productprice_price as product_price, product_prices.productdescription_product as product_description, product_prices.uid as uid,product_prices.updated_at  as updated_at')
    .group('magisterial_districts.zonedistrict, magisterial_districts.magisterialdistrict_code, magisterial_districts.magisterialdistrict_province, product_prices.productprice_price, product_prices.productdescription_product,product_prices.uid,product_prices.updated_at')
    	
    end
  end