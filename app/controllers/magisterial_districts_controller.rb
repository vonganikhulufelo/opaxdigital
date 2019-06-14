class MagisterialDistrictsController < ApplicationController
  before_action :require_login
  before_action :set_magisterial_district, only: [:show, :edit, :update, :destroy]

  # GET /magisterial_districts
  # GET /magisterial_districts.json
  def index
    @magisterial_districts = MagisterialDistrict.where(user_id: current_user.user_id).search(params[:search]).paginate(page: params[:page], per_page: 50).order('updated_at DESC')
  end

  # GET /magisterial_districts/1
  # GET /magisterial_districts/1.json
  def show
  end

  # GET /magisterial_districts/new
  def new
    @magisterial_district = MagisterialDistrict.new
  end

  # GET /magisterial_districts/1/edit
  def edit
  end



def import

  CSV.foreach(params[:file].path, headers: true) do |row|

    @zone = Zone.find_by(zone_description: row[0])

    if !@zone
    @zone1 = Zone.create!(zone_description: row[0],user_id: current_user.user_id)
    @mg = MagisterialDistrict.create!(zone_id: @zone1.id,magisterialdistrict_zone: row[0],magisterialdistrict_district: row[1],magisterialdistrict_code: row[2],magisterialdistrict_province: row[3],user_id: current_user.user_id)
      @mg.update(uid: "md_" + @mg.id.to_s)
        @dis = @mg.created_at.to_s + "$" + row[0].to_s + '$' + row[1].to_s + '$' + row[2].to_s + '$' + row[3].to_s
        Log.create!(description: @dis, username: current_user.name, uid: "md_" + @mg.id.to_s,user_id: current_user.user_id)
    else
      @mg1 = MagisterialDistrict.create!(zone_id: @zone.id,magisterialdistrict_zone: row[0],magisterialdistrict_district: row[1],magisterialdistrict_code: row[2],magisterialdistrict_province: row[3],user_id: current_user.user_id)
      @mg1.update(uid: "md_" + @mg1.id.to_s)
        @dis1 = @mg1.created_at.to_s + "$" + row[0].to_s + '$' + row[1].to_s + '$' + row[2].to_s + '$' + row[3].to_s
        
        Log.create!(description: @dis1, username: current_user.name, uid: "md_" + @mg1.id.to_s,user_id: current_user.user_id)
    end
 
  end
  redirect_to magisterial_districts_url, notice: "Zone imported."
end



  # POST /magisterial_districts
  # POST /magisterial_districts.json
  def create
    #@magisterial_district = MagisterialDistrict.new(magisterial_district_params)

    @zone = Zone.find_by(zone_description: params[:magisterial_district][:magisterialdistrict_zone])

    if !@zone
      @zone1 = Zone.create!(zone_description: params[:magisterial_district][:magisterialdistrict_zone],user_id: current_user.user_id)
      @magisterial_district = MagisterialDistrict.new(user_id: current_user.user_id,magisterialdistrict_zone: params[:magisterial_district][:magisterialdistrict_zone],magisterialdistrict_code: params[:magisterial_district][:magisterialdistrict_code],magisterialdistrict_district: params[:magisterial_district][:magisterialdistrict_district],magisterialdistrict_province: params[:magisterial_district][:magisterialdistrict_province],:zone_id => @zone1.id)
      respond_to do |format|
        if  @magisterial_district.save
          @magisterial_district.update(uid: "md_" + @magisterial_district.id.to_s)
          @dis = @magisterial_district.created_at.to_s + "$" + @magisterial_district.magisterialdistrict_zone.to_s + '$' + @magisterial_district.magisterialdistrict_district.to_s + '$' + @magisterial_district.magisterialdistrict_code.to_s + '$' + @magisterial_district.magisterialdistrict_province.to_s
        Log.create!(description: @dis, username: current_user.name, uid: "md_" + @magisterial_district.id.to_s,user_id: current_user.user_id)
          format.html { redirect_to magisterial_districts_url, notice: 'Magisterial district was successfully created.' }
          format.json { render :show, status: :ok, location: @magisterial_district }
        else
          format.html { render :new }
          format.json { render json: @magisterial_district.errors, status: :unprocessable_entity }
        end
      end
    else
      @magisterial_district1 = MagisterialDistrict.new(user_id: current_user.user_id,magisterialdistrict_zone: params[:magisterial_district][:magisterialdistrict_zone],magisterialdistrict_district: params[:magisterial_district][:magisterialdistrict_district],magisterialdistrict_province: params[:magisterial_district][:magisterialdistrict_province],:zone_id => @zone.id)
      respond_to do |format|
        if  @magisterial_district1.save
          @magisterial_district1.update(uid: "md_" + @magisterial_district1.id.to_s)
          @dis1 = @magisterial_district1.created_at.to_s + "$" + @magisterial_district1.magisterialdistrict_zone.to_s + '$' + @magisterial_district1.magisterialdistrict_district.to_s + '$' + @magisterial_district1.magisterialdistrict_code.to_s + '$' + @magisterial_district1.magisterialdistrict_province.to_s
        Log.create!(description: @dis1, username: current_user.name, uid: "md_" + @magisterial_district1.id.to_s,user_id: current_user.user_id)
          format.html { redirect_to magisterial_districts_url, notice: 'Magisterial district was successfully created.' }
          format.json { render :show, status: :ok, location: @magisterial_district1 }
        else
          format.html { render :new }
          format.json { render json: @magisterial_district.errors, status: :unprocessable_entity }
        end
      end

    end

  end

  # PATCH/PUT /magisterial_districts/1
  # PATCH/PUT /magisterial_districts/1.json
  def update
    respond_to do |format|
      if @magisterial_district.update(magisterial_district_params)
        @dis1 = @magisterial_district.created_at.to_s + "$" + @magisterial_district.magisterialdistrict_zone.to_s + '$' + @magisterial_district.magisterialdistrict_district.to_s + '$' + @magisterial_district.magisterialdistrict_code.to_s + '$' + @magisterial_district.magisterialdistrict_province.to_s
        Log.create!(description: @dis1, username: current_user.name, uid: @magisterial_district.uid,user_id: current_user.user_id)
        format.html { redirect_to magisterial_districts_url, notice: 'Magisterial district was successfully updated.' }
        format.json { render :show, status: :ok, location: @magisterial_district }
      else
        format.html { render :edit }
        format.json { render json: @magisterial_district.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /magisterial_districts/1
  # DELETE /magisterial_districts/1.json
  def destroy
    @magisterial_district.destroy
    respond_to do |format|
      format.html { redirect_to magisterial_districts_url, notice: 'Magisterial district was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_magisterial_district
      @magisterial_district = MagisterialDistrict.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def magisterial_district_params
      params.require(:magisterial_district).permit(:user_id, :magisterialdistrict_zone, :magisterialdistrict_district, :magisterialdistrict_code, :magisterialdistrict_province)
    end
end
