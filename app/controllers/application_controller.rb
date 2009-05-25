class ApplicationController < ActionController::Base
  include Hammock::RestfulActions

  helper :all
  layout 'application'
  protect_from_forgery


  private

  def current_user
    nil
  end
end
