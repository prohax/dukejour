class ApplicationController < ActionController::Base
  helper :all
  layout 'application'
  protect_from_forgery

  private

  def current_user
    @current_user ||= User.find_or_create_with :ip => request.remote_ip
  end
  helper_method :current_user

  def render_juggernaut function, data
    JuggernautHelpers.call_via_juggernaut function, data
    render :nothing => true
  end
end
