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

#

  def apply_omniauth(omni)
    authentications.build(:provider => omni['provider'],
                          :uid => omni['uid'],
                          :token => token = omni['credentials']['token'],
                          :token_secret => omni['credentials']['secret'])
  end

  def password_required?
    super && (authentications.empty? || !password.blank?)
  end

  # Overrides Devise method.
  # To update password if user only authenticated through Twitter, and user was created with blank pw.
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def send_tweet(content)
    twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key =         ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret =      ENV['TWITTER_CONSUMER_SECRET']
      
      config.access_token =         ENV['TWITTER_YOUR_ACCESS_TOKEN']
      config.access_token_secret =  ENV['TWITTER_YOUR_ACCESS_SECRET']
    end
    # Call, and define elsewhere the method to parse, shorten, and insert the tweet
    twitter_client.update(content)
  end

end

########################
# railscast #235 way






#########################
#
#  def self.from_omniauth(auth, the_current_user)
#    authentication = Authentication.where(:provider => auth.provider, 
#                                          :uid => auth.uid.to_s, 
#                                          :token => auth.credentials.token, 
#                                          :secret => auth.credentials.secret).first_or_initialize
#      authentication.profile_page = auth.info.urls.first.last unless authentication.persisted?
#    
#    # Handle twitter not providing email.
#    if authentication.user.blank?
#      user = the_current_user.nil? ? User.where('email = ?', auth['info']['email']).first : the_current_user
#      if user.blank?
#        user = User.new
#        #user.skip_confirmation!
#        user.password = Devise.friendly_token[0, 20]
#        user.fetch_details(auth)
#        user.save
#      end
#      authentication.user = user
#      authentication.save
#    end
#    authentication.user
#  end
#
#  def self.new_with_session(params, session)
#    if session["devise.user_attributes"]
#      new(session["devise.user_attributes"], without_protection: true) do |user|
#        user.attributes = params
#        user.valid?
#      end
#    else
#      super # references devise's create new user instance.
#    end
#  end
#
#  def fetch_details(auth)
#    self.username = auth.info.name
#    self.email = auth.info.email
#    self.image = URI.parse(auth.info.image)
#  end
#
#  def password_required?
#    super && Authentication.provider.blank? 
#    # "provider" attribute isn't on user table. how to reference it from authentication model? 
#    # Is checking pre-existing values required - what if not signed in?
#  end
