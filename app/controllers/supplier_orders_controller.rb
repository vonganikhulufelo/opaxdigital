class SupplierOrdersController < ApplicationController

    def payment
        @payemnts = SupplierPaymentTerm.where(supplier_id: params[:id])
        render json: {payments:  @payemnts}
    end

    def zone
        @zones = SPayMDistrict.where(supplier_payment_term_id: params[:id])
        render json: {zones: @zones}
    end

    def product_name
        @product = SPayMProductPrice.where(s_pay_m_district_id: params[:id])
        render json: {products: @product}
    end
    def product_price
        @product = SPayMProductPrice.find(params[:id])
        render json: {products: @product}
    end
end
