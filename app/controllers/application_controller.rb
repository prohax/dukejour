class ApplicationController < ActionController::Base
  include Hammock::RestfulActions

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  def current_user
    nil
  end
end
