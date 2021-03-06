class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  protected
    def authenticate_with_token
      authenticate_with_http_token do |token, options|
        #Token token = 67ygubjkn; email=email@example.com
        user_email = options[:email]
        user = User.find_by(email: user_email) if user_email.present?

        if user && secure_token_compare(user.auth_token, token)
          @current_user = user
        else
          self.headers['WWW-Authenticate'] = 'Token realm-"Application"'
          render json: { errors: "Invalid session data" }, status: :unauthorized
        end
      end
    end

    def current_user
      @current_user
    end

  private

    # constant-time comparison algorithm to prevent timing attacks
    # devise
    def secure_token_compare(a, b)
      return false if a.blank? || b.blank? || a.bytesize != b.bytesize
      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end

    def paginate(collection)
      collection.page(params[:page]).per(params[:per_page])
    end

    def meta_pagination(collection)
      {
        pagination: {
          per_page: params[:per_page] || 10,
          total_pages: collection.total_pages,
          total_objects: collection.total_count
        }
      }
    end

end
