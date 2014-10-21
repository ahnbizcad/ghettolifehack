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
#  comments_count         :integer          default(0), not null
#  favorites_count        :integer          default(0), not null
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
         :omniauthable, omniauth_providers: [ :twitter, :facebook ]

  has_many :authentications, dependent: :destroy
  has_many :hacks
 
  has_many :favorite_hacks, through: :favorites, source: :hack
  has_many :favorites

  has_many :comments
  acts_as_voter

  

  validates :email,
            presence: true,
            :length => { in: 10..24 } #use regex 
  validates :username,
            presence: true,
            :uniqueness => { case_sensitive: false },
            :length => { in: 4..24 }
  # Password length validation is in 
  # devise.rb initializer
  # config.password_length = 

  # Scopes
  #others who also favorited this


  ### Authentication

  def apply_omniauth(omni)
    # Sets User model info as necessary, depending on existing values and provided values
    self.email    = omni['info']['email']    if self.email.blank?
    self.username = omni['info']['nickname'] if self.username.blank?
    self.authentications.build(
      :provider      => omni['provider'],
      :uid           => omni['uid'],
      :token         => omni['credentials']['token'],
      :token_secret  => omni['credentials']['secret'],
    )
  end

  # Overrides Devise method
  # For logins and signins only, not for edit registration
  def password_required?
    # super = !persisted? || !password.nil? || !password_confirmation.nil?
    super && (authentications.blank?)    
  end

  #def current_password_required?(params)
  #  encrypted_password.present? && params[:user][:password].present?
  #end

  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    # Different from original
    has_authentication_but_not_encrypted_password = encrypted_password.blank?   && authentications.present?
    has_encrypted_password_but_not_changing       = encrypted_password.present? && params[:password].blank?
    #
    result = if valid_password?(current_password) || has_encrypted_password_but_not_changing || has_authentication_but_not_encrypted_password
      update_attributes(params, *options)
    else
      self.assign_attributes(params, *options)
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords
    result
  end

end
