class TanksController < ApplicationController
	before_action :require_login
  	before_action :set_tank, only: [:show, :edit, :update, :destroy]
  
  def index
  	 @product_descriptions = ProductDescription.where(user_id: current_user.user_id)
  	 @tanks = Tank.where(user_id: current_user.user_id)
  end

  def new
  	@tank = Tank.new
  	@product_descriptions = ProductDescription.where(user_id: current_user.user_id)
  end

  def create
   @tank = Tank.new(tank_params)

    respond_to do |format|
      if @tank.save
        @tank.update(uid: "t_" + @tank.id.to_s, product_description: params[:product_description])
        @product_description = ProductDescription.find(params[:product_description])
        @dis = @tank.tank_number.to_s + '$' + @product_description.productdescription_product.to_s  + '$' + @tank.stock_in.to_s + '$' + @tank.stock_out.to_s + '$' + @tank.current_stock.to_s + '$' + @tank.product_description.to_s + '$' + @tank.tank_size.to_s
        
        Log.create!(description: @dis, username: current_user.name, uid: @tank.uid.to_s, user_id: current_user.user_id)

        format.html { redirect_to tanks_url, notice: 'tank was successfully created.' }
        format.json { render :show, status: :created, location: @tank }
      else
        format.html { render :new }
        format.json { render json: @tanks.errors, status: :unprocessable_entity }
      end
  end
  end

  def show
    @tanks = Tank.where(user_id: current_user.user_id).select('tank_number, id, (current_stock/tank_size * 100) as current_stock')
  end

  def edit
  	@product_descriptions = ProductDescription.where(user_id: current_user.user_id)
  end

 def update
    respond_to do |format|
      if @tank.update(tank_params) 
        @tank.update(product_description: params[:product_description])
        @product_description = ProductDescription.find(params[:product_description])
        @dis = @tank.tank_number.to_s + '$' + @product_description.productdescription_product.to_s  + '$' + @tank.stock_in.to_s + '$' + @tank.stock_out.to_s + '$' + @tank.current_stock.to_s + '$' + @tank.product_description.to_s + '$' + @tank.tank_size.to_s
        
        Log.create!(description: @dis, username: current_user.name, uid: @tank.uid.to_s, user_id: current_user.user_id)
        
        format.html { redirect_to tanks_url, notice: 'tank was successfully created.' }
        format.json { render :show, status: :created, location: @tank }
      else
        format.html { render :new }
        format.json { render json: @tanks.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@tank.destroy
    respond_to do |format|
      format.html { redirect_to tanks_url, notice: 'Tank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

   private

   	def set_tank
      @tank = Tank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tank_params
      params.require(:tank).permit(:tank_number, :stock_in, :stock_out, :current_stock, :product_description, :tank_size, :user_id)
    end
end
