class CustomersController < ApplicationController
  before_action :require_login
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.where(user_id: current_user.user_id).search(params[:search]).paginate(page: params[:page], per_page: 50).order('customer_name ASC')
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Customer. #{@customer.id}",
        page_size: 'A4',
        template: "customers/show.html.erb",
        layout: "pdf.html",
        orientation: "Landscape",
        lowquality: true,
        zoom: 1,
        dpi: 75
      end
    end
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    @payment_terms = PaymentTerm.where(user_id: current_user.user_id)
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save

        @customer.update(uid: "c_" + @customer.id.to_s)
        @dis = @customer.customer_name.to_s + '$' + @customer.customer_address.to_s + '$' + @customer.customer_contact.to_s + '$' + @customer.customer_email.to_s

        Log.create!(description: @dis, username: current_user.name, uid: "c_" + @customer.id.to_s, user_id: current_user.user_id)

        params[:paymentterm_description].each do | payment |

        @pt = PaymentTerm.find(payment)
        @cus = CustomerPaymentTerm.find_by(payment_term_id: payment, customer_id: @customer.id)
          if !@cus
            CustomerPaymentTerm.create(payment_term_description: @pt.paymentterm_description, customer_id: @customer.id, payment_term_id: payment)
          end
        end

        format.html { redirect_to customers_url, notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        @dis = @customer.customer_name.to_s + '$' + @customer.customer_address.to_s + '$' + @customer.customer_contact.to_s + '$' + @customer.customer_email.to_s
 
        Log.create!(description: @dis, username: current_user.name, uid: @customer.uid.to_s,user_id: current_user.user_id)
        params[:paymentterm_description].each do | payment |
        @pt = PaymentTerm.find(payment)
        @pay = CustomerPaymentTerm.find_by(payment_term_id: payment, customer_id: @customer.id)
          if !@pay
            CustomerPaymentTerm.create(payment_term_description: @pt.paymentterm_description, customer_id: @customer.id, payment_term_id: payment)
          end
        end

        @cust = CustomerPaymentTerm.where(customer_id: @customer.id)

        if @cust.present?
          @cust.each do | cust |
            if params[:paymentterm_description].include?(cust.payment_term_id.to_s)
              
            else
              cust.destroy
            end
          end
        end
        format.html { redirect_to customers_url, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:customer_name, :customer_address, :customer_contact, :customer_email, :location,:user_id)
    end
end
