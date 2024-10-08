class FindForOauth
  def initialize(provider, uid, email)
    @provider = provider
    @uid = uid
    @email = email
  end

  def call
    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: provider, uid: uid.to_s)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: provider, uid: uid.to_s)
    end
    user
  end

  private

  attr_reader :provider, :uid, :email
end
