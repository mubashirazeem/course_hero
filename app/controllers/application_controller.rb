class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :authenticate_user!
  # load_and_authorize_resource unless: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      users_path
    else
      super
    end
  end
end
