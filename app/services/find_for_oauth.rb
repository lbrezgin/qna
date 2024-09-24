class FindForOauth
  attr_reader :provider, :uid, :email

  def initialize(provider, uid, email)
    @provider = provider
    @uid = uid
    @email = email
  end

  def call
    user = User.where(email: email).first
    if user
      user.create_authorization(provider, uid)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(provider, uid)
    end
    user
  end
end

