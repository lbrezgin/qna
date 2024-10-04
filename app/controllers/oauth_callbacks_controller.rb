class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    prepare_authentication(request.env['omniauth.auth'])
  end

  def twitter
    prepare_authentication(request.env['omniauth.auth'])
  end

  def get_email
    @email = params[:email]

    @user = User.find_for_oauth(session[:provider], session[:uid], @email)
    authenticate(@user, session[:provider])
  end

  private

  def prepare_authentication(request)
    session[:provider] = request[:provider]
    session[:uid] = request[:uid]
    @email = request[:info][:email]

    @user = User.have_authorization(session[:provider], session[:uid])

    if @user
      authenticate(@user, session[:provider])
    else
      if @email
        @user = User.find_for_oauth(session[:provider], session[:uid], @email)
        authenticate(@user, session[:provider])
      else
        render "shared/email_form"
      end
    end
  end

  def authenticate(user, provider)
    if user&.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end


