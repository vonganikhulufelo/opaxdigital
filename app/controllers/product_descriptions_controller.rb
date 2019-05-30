class ProductDescriptionsController < ApplicationController
  before_action :require_login
  before_action :set_product_description, only: [:show, :edit, :update, :destroy]

  # GET /product_descriptions
  # GET /product_descriptions.json
  def index
    @product_descriptions = ProductDescription.where(user_id: current_user.user_id)
  end

  # GET /product_descriptions/1
  # GET /product_descriptions/1.json
  def show
  end

  # GET /product_descriptions/new
  def new
    @product_description = ProductDescription.new
  end

  # GET /product_descriptions/1/edit
  def edit
  end

  def import
        CSV.foreach(params[:file].path, headers: true) do |row|
          @product_description = ProductDescription.find_by(productdescription_product: row[0])
          if !@product_description
            @desc = ProductDescription.create!(productdescription_product: row[0], user_id: current_user.user_id)
            @uuip =  @desc.update(uid: 'pd_' + @desc.id.to_s)
            @dis = row[0].to_s
              
            Log.create!(description: @dis, username: current_user.name, uid: 'pd_' + @desc.id.to_s, user_id: current_user.user_id)
          end
        end
    redirect_to product_descriptions_url, notice: "Products imported."
  end

  # POST /product_descriptions
  # POST /product_descriptions.json
  def create
    @product_description = ProductDescription.new(product_description_params)
    @product_description1 = ProductDescription.find_by(productdescription_product: params[:product_description][:productdescription_product], user_id: current_user.user_id)

    respond_to do |format|
      if !@product_description
        if @product_description.save
            @product_description.update(uid: 'pd_' + @product_description.id.to_s)
            @description = @product_description.productdescription_product.to_s
            Log.create!(description: @description, username: current_user.name, uid: 'pd_' + @product_description.id.to_s, user_id: current_user.user_id)
          format.html { redirect_to product_descriptions_url, notice: 'Product description was successfully created.' }
          format.json { render :show, status: :created, location: @product_description }
        else
          format.html { render :new }
          format.json { render json: @product_description.errors, status: :unprocessable_entity }
        end
      else
        format.html {redirect_to product_descriptions_url, notice: 'Product description already exist.'}
      end
    end
  end

  # PATCH/PUT /product_descriptions/1
  # PATCH/PUT /product_descriptions/1.json
  def update
    respond_to do |format|
      if @product_description.update(product_description_params)
        @description = @product_description.productdescription_product.to_s
          Log.create!(description: @description, username: current_user.name, uid: @product_description.uid.to_s, user_id: current_user.user_id)
        format.html { redirect_to product_descriptions_url, notice: 'Product description was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_description }
      else
        format.html { render :edit }
        format.json { render json: @product_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_descriptions/1
  # DELETE /product_descriptions/1.json
  def destroy
    @product_description.destroy
    respond_to do |format|
      format.html { redirect_to product_descriptions_url, notice: 'Product description was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_description
      @product_description = ProductDescription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_description_params
      params.require(:product_description).permit(:productdescription_product, :user_id)
    end
end
