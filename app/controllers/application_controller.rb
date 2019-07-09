class ApplicationController < ActionController::Base
	before_action :require_login
	rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
	
	private
	def not_authenticated
	  redirect_to login_path, flash: { danger: "Please login first" }
	end
end
