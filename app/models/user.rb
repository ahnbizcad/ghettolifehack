# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  username               :string(255)
#  admin                  :boolean          default(FALSE)
#  image                  :string(255)
#  points                 :integer          default(0), not null
#  hacks_count            :integer          default(0), not null
#  comment_threads_count  :integer          default(0), not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, omniauth_providers: [ :twitter ]

  has_many :hacks
  has_many :comments
  acts_as_voter

  has_many :authentications

  validates :username,
            presence: true,
            :uniqueness => { case_sensitive: false },
            length: { in: 4..20 }

#

  SOCIALS = {
    twitter:  'Twitter',
    facebook: 'Facebook'
  }

  def self.from_omniauth(auth, the_current_user)
    authentication = Authentication.where(:provider => auth.provider, 
                                        :uid => auth.uid.to_s, 
                                        :token => auth.credentials.token, 
                                        :secret => auth.credentials.secret).first_or_initialize
    authentication.profile_page = auth.info.urls.first.last unless authentication.persisted?
    if authentication.user.blank?
      user = the_current_user.nil? ? User.where('email = ?', auth['info']['email']).first : the_current_user
      if user.blank?
        user = User.new
        user.skip_confirmation!
        user.password = Devise.friendly_token[0, 20]
        user.fetch_details(auth)
        user.save
      end
      authentication.user = user
      authentication.save
    end
    authentication.user
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def fetch_details(auth)
    self.name = auth.info.name
    self.email = auth.info.email
    self.photo = URI.parse(auth.info.image)
  end

  def password_required?
    super && provider.blank?
  end

end
