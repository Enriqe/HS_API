class Api::V1::SessionsController < Api::V1::BaseController

  def create
    # session: {
    #  email: "email@example.com",
    #  password: "12345678"
    #  }
    user_password = params[:session][:password]
    user_email = params[:session][:email]

    #aqui creo que falto algo
    #falta el serializer
    user = User.find_by(email: user_email) if user_email.present?

    if user.present? && user.authenticate(user_password)
      sign_in user

      render json: user, status: :ok
    else
      render json: { session: { errors: "Invalid email or password" } }, status: :unprocessable_entity
    end
  end

  private

    def sign_in(user)
      user.generate_authentication_token!
      user.save
    end

end
