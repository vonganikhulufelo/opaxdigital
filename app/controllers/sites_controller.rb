class SitesController < ApplicationController
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    @sites = Site.where(user_id: current_user.user_id).search(params[:search]).paginate(page: params[:page], per_page: 50).order('site_number ASC')
    authorize! :create, @sites
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @site = Site.new
    authorize! :create, @site
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @site = Site.new(site_params)
    authorize! :create, @site
    respond_to do |format|
      if @site.save
        @site.update(uid: 'st_' + @site.id.to_s)

        Log.create!(description: @site.site_number + '$' + @site.site_location.to_s, username: current_user.name, uid: 'st_' + @site.id.to_s, user_id: current_user.user_id)
        
        format.html { redirect_to sites_path, notice: 'Site was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      authorize! :edit, @site
      if @site.update(site_params)

        Log.create!(description: @site.site_number + '$' + @site.site_location.to_s, username: current_user.name, uid: @site.uid.to_s, user_id: current_user.user_id)
        
        format.html { redirect_to sites_path, notice: 'Site was successfully updated.' }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize! :destroy, @site
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url, notice: 'Site was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_params
      params.require(:site).permit(:site_number, :site_location,:user_id)
    end
end
