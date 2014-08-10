##
# override session controller (devise)

class SessionsController < ::Devise::SessionsController
    # skip_before_filter :require_no_authentication, :only => [:new, :create]

    def create
        resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        set_flash_message :notice, :signed_in
        sign_in(resource_name, resource)
        
        unless resource.nil?
            session[:user_id] = resource.id
            @current_user = resource
            current_user = resource
        end

        respond_to do |format|
            redirect_url = request.referrer
            redirect_url = params[:next] if params[:next].present?
            format.html { redirect_to redirect_url, notice: 'Sign in success.' }
        end
    end

    def destroy
        super
    end

    def registration_params
      params.require(:user).permit(:password, :email, :firstname, :lastname)
    end
end