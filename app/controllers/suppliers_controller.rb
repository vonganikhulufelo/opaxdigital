class SuppliersController < ApplicationController
  before_action :require_login
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  # GET /suppliers
  # GET /suppliers.json
  def index
    @suppliers = Supplier.where(user_id: current_user.user_id).order('supplier_name ASC')
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
   
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = current_user.suppliers.new(supplier_params)

    respond_to do |format|
      if @supplier.save
        @supplier.update(uid: "s_" + @supplier.id.to_s)
        @dis = @supplier.supplier_name.to_s + '$' + @supplier.supplier_address.to_s + '$' + @supplier.supplier_contact.to_s + '$' + @supplier.supplier_email.to_s
        
        Log.create!(description: @dis, username: current_user.name, uid: "s_" + @supplier.id.to_s, user_id: current_user.user_id)

        params[:paymentterm_description].each do | payment |
          @pt = PaymentTerm.find(payment)
          @pay = SupplierPaymentTerm.find_by(payment_term_id: payment, supplier_id: @supplier.id)
          if !@pay
            SupplierPaymentTerm.create(payment_term_description: @pt.paymentterm_description, supplier_id: @supplier.id, payment_term_id: payment)
          end
        end
        format.html { redirect_to suppliers_url, notice: 'Supplier was successfully created.' }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        @dis = @supplier.supplier_name.to_s + '$' + @supplier.supplier_address.to_s + '$' + @supplier.supplier_contact.to_s + '$' + @supplier.supplier_email.to_s
        
        Log.create!(description: @dis, username: current_user.name, uid: @supplier.uid.to_s,user_id: current_user.user_id)
        params[:paymentterm_description].each do | payment |
          @pt = PaymentTerm.find(payment)
          @pay = SupplierPaymentTerm.find_by(payment_term_id: payment, supplier_id: @supplier.id)
          if !@pay
            SupplierPaymentTerm.create(payment_term_description: @pt.paymentterm_description, supplier_id: @supplier.id, payment_term_id: payment)
          end
        end

        @supp = SupplierPaymentTerm.where(supplier_id: @supplier.id)

        if @supp.present?
          @supp.each do | supp |
            if params[:paymentterm_description].include?(supp.payment_term_id.to_s)
              
            else
              supp.destroy
            end
          end
        end

        format.html { redirect_to suppliers_url, notice: 'Supplier was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_url, notice: 'Supplier was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(:supplier_name, :supplier_address, :supplier_contact, :supplier_email, :user_id)
    end
end
