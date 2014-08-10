##
# override registration controller (devise)

class RegistrationsController < Devise::RegistrationsController
	skip_before_filter :require_no_authentication, :only => [:new, :create]

	def new
	    super
	end

	def create
		@user = User.new(registration_params)

	    respond_to do |format|
	      if @user.save
	      	session[:user_id] = @user.id
	      	@current_user = @user
	      	current_user = @user
	        format.html { redirect_to root_url, notice: 'User was successfully created.' }
	      else
	        format.html { render action: 'new' }
	      end
	    end
	end

	def edit
	    @user = current_user
	end

	def update
		account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
		if account_update_params[:password].blank?
	      account_update_params.delete("password")
	      account_update_params.delete("password_confirmation")
	    end
		@user = User.find(current_user.id)
	    respond_to do |format|
	      if @user.update(account_update_params)
	      	sign_in @user, :bypass => true
	        format.html { redirect_to root_url, notice: 'User was successfully updated.' }
	      else
	        format.html { render action: 'edit' }
	      end
	    end

	end

	def destroy
		super
	end

	def cancel
		super
	end

	private

	def registration_params
      params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end

    def needs_password?(user, params)
	    user.email != params[:user][:email] ||
	    params[:user][:password].present?
	end
end