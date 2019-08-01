class TanksController < ApplicationController
	before_action :require_login
  	before_action :set_tank, only: [:show, :edit, :update, :destroy]
  
  def index
    @site = Site.find(params[:site_id])
   @tanks = @site.tanks
  	 #@tanks = User.joins(:product_descriptions, sites: [:tanks]).select('DISTINCT(product_descriptions.productdescription_product),tanks.tank_number, tanks.tank_volume, tanks.current_stock,tanks.id as tank_id, sites.id as site_id,tanks.updated_at').where('sites.id = ?', params[:site_id]).group('tanks.updated_at,tanks.tank_number, tanks.tank_volume, tanks.current_stock,tanks.id,sites.id,product_descriptions.productdescription_product')
  end

  def new
    @site = Site.find(params[:site_id])
  	@tank = @site.tanks.build
    @product_description = ProductDescription.where(user_id: current_user.user_id)
  end

  def create
    @site = Site.find(params[:site_id])
   @tank = @site.tanks.new(tank_params)

    respond_to do |format|
      if @tank.save
        @tank.update(uid: "st_" + @tank.id.to_s)
        @product_description = ProductDescription.find(params[:product_description_id])
        @dis = @tank.tank_number.to_s + '$' + @product_description.productdescription_product.to_s  + '$' + @tank.stock_in.to_s + '$' + @tank.stock_out.to_s + '$' + @tank.current_stock.to_s + '$' + @tank.product_description_id.to_s + '$' + @tank.tank_volume.to_s
        
        Log.create!(description: @dis, username: current_user.name, uid: "st_" + @tank.id.to_s, user_id: current_user.user_id)

        format.html { redirect_to site_url(@tank.site_id), notice: 'tank was successfully created.' }
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
  	@site = Site.find(params[:site_id])
   @tank = @site.tanks.find(params[:id])
  end

 def update
    respond_to do |format|
      if @tank.update(tank_params) 
        @product_description = ProductDescription.find(params[:product_description_id])
        @dis = @tank.tank_number.to_s + '$' + @product_description.productdescription_product.to_s  + '$' + @tank.stock_in.to_s + '$' + @tank.stock_out.to_s + '$' + @tank.current_stock.to_s + '$' + @tank.product_description_id.to_s + '$' + @tank.tank_volume.to_s
        
        Log.create!(description: @dis, username: current_user.name, uid: @tank.uid.to_s, user_id: current_user.user_id)
        
        format.html { redirect_to site_url(@tank.site_id), notice: 'tank was successfully created.' }
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
      format.html { redirect_to site_url(@tank.site_id), notice: 'Tank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

   private

   	def set_tank
     @site = Site.find(params[:site_id])
     @tank = @site.tanks.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tank_params
      #params.require(:tank).permit(:tank_number, :stock_in, :stock_out, :current_stock, :product_description_id, :tank_size, :user_id)
    {tank_number: params[:tank][:tank_number], stock_in: params[:tank][:stock_in], stock_out: params[:tank][:stock_out],current_stock: params[:tank][:current_stock],product_description_id: params[:product_description_id],tank_volume: params[:tank][:tank_volume], user_id: current_user.user_id}
    end
end
