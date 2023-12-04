class ApplicationController < ActionController::Base

  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end

  # ................Authenticate user!..............
  # byebug
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :update_sanitized_params, if: :devise_controller?


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :type, :mobile, :address])
  end

  # def update_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :type, :mobile, :address, :encrypted_password])
  # end

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :type, :mobile, :address, :encrypted_password])
  end
  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_in) do |user_params|
  #     user_params.permit(:username, :email)
  #   end
  # end
  # ................Include JsonWebToken..............

  # include JsonWebToken

  # # ................Authentication request............

  # before_action :authenticate_request

  # # ...................Authenticate User..................

  # def authenticate_request
  #   begin
  #     header = request.headers[ 'Authorization' ]
  #     header = header.split(" ").last if header
  #     decoded = jwt_decode(header)
  #     @current_user = User.find(decoded[:user_id])
  #   rescue JWT::DecodeError => e
  #      render json: { error: 'Invalid token' }, status: :unprocessable_entity
  #   end
  #   rescue ActiveRecord::RecordNotFound
  #     render json: "No record found.."
  # end

  #------------------OWNER HAS RIGHT TO------------------
    def owner_has_right_to
      unless current_user.type == "Owner"
        respond_to do |format|
          format.json { render json: {message: "Customer's don't have the access"}}
          format.html { redirect_to root_path }
        end
      end
    end

end
