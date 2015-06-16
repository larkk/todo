class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :authorizations
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :delete_all

  scope :all_except, ->(user) { where.not(id: user) }

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    if auth.info.try(:email)
      email = auth.info[:email]
    else
      return false
    end

    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email,
                      password: password,
                      password_confirmation: password)
      if user.valid?
        user.save!
        user.create_authorization(auth)
      else
        return false
      end
    end
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.delay.digest(user)
    end
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
