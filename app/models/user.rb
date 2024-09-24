class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author_of?(entity)
    entity.user_id == self.id
  end

  def self.find_for_oauth(provider, uid, email)
    FindForOauth.new(provider, uid, email).call
  end

  def create_authorization(provider, uid)
    self.authorizations.create(provider: provider, uid: uid.to_s) if self
  end

  def self.have_authorization(provider, uid)
    authorization = Authorization.where(provider: provider, uid: uid.to_s).first
    return authorization.user if authorization
  end
end
