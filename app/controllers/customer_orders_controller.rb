class CustomerOrdersController < ApplicationController

    def payment
        @payemnts = CustomerPaymentTerm.where(customer_id: params[:id])
        render json: {payments:  @payemnts}
    end

    def zone
        @zones = CPayMDistrict.where(customer_payment_term_id: params[:id])
        render json: {zones: @zones}
    end

    def product_name
        @product = CPayMProductPrice.where(c_pay_m_district_id: params[:id])
        render json: {products: @product}
    end
    def product_price
        @product = CPayMProductPrice.find(params[:id])
        render json: {products: @product}
    end
end
