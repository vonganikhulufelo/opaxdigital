class PriceLookupsController < ApplicationController
    def index
        @price_lookups = current_user.zones.joins(:magisterial_districts, :product_prices).select('magisterial_districts.zonedistrict as zone_district, magisterial_districts.magisterialdistrict_code as magisterial_code, product_prices.productprice_price as product_price, product_prices.productdescription_product as product_description')
        .group('magisterial_districts.zonedistrict, magisterial_districts.magisterialdistrict_code, magisterial_districts.magisterialdistrict_province, product_prices.productprice_price, product_prices.productdescription_product')
    end
  end