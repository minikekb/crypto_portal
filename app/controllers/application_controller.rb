class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  protected # Метод доступен только внутри контроллера

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_up_path_for(resource)
    root_path
  end
end
