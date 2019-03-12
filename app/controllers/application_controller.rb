class ApplicationController < ActionController::Base
  def after_sign_out_path
    root_path
  end
end
