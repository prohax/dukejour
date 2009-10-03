class ApplicationController < ActionController::Base
  include Hammock::RestfulActions

  helper :all
  layout 'application'
  protect_from_forgery

  after_filter :log_hit

  private

  def current_user
    nil
  end
end
