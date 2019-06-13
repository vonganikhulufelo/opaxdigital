require 'csv'
class ImportProductPrice
  @queue = :default
  def self.perform(file)

  	CSV.foreach(file.path, headers: true) do |row|

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
  end
end