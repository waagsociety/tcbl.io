#allows the superadmin to become any user, for debugging purposes
class AdminController < ApplicationController
	before_filter :require_superadmin

	def become
		user = User.find(params[:id])
		session[:user_id] = user.id
		redirect_to root_url # or user_root_url
	end

private

  def require_superadmin
    if current_user
      unless superadmin 
  		  return redirect_to root_url, notice: "Not authorized"
      end
    else
      return redirect_to signin_url
    end
  end

  def superadmin
    current_user.has_role? :superadmin
  end
end
