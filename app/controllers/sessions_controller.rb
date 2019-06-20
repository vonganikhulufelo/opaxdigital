class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  def new
    redirect_to supplier_rebates_path if current_user.present?
  end

  def create
    if @user = login(params[:email], params[:password], params[:remember])
      redirect_to supplier_rebates_path, flash: { success: "Login successful" }
    else
      flash.now[:danger] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path, flash: { danger: "Logged out!" }
  end
end
