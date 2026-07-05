class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def authenticate_admin!
    unless current_user&.admin?
      redirect_to admin_redirect_path, alert: "No tienes permiso para hacer eso."
    end
  end

  # Override in subclasses to send unauthorized visitors somewhere more specific.
  def admin_redirect_path
    root_path
  end
end
