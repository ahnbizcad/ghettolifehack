class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :hacks
  has_many :comments 

  validates :username,
            presence: true,
            :uniqueness => { case_sensitive: false },
            length: { in: 4..20 }

end
