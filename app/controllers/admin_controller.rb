class AdminController < ApplicationController
	def set_to
		if current_user.present?
			current_user.update_attribute(:is_admin, true)
			redirect_to :back
		end
	end
end