class ApplicationController < ActionController::Base
	include DeviseWhitelist
	def frequent_groups
		@frequent_groups = current_user.find_frequent_groups
	end
end
