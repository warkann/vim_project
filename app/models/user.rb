class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  mount_uploader :user_img, UserImgUploader

  has_many :plugins
  has_many :posts
  has_many :colorschemas
  has_many :dotfiles
  has_many :hacks

  extend FriendlyId
  friendly_id :slug_nickname, use: :slugged

  def slug_nickname
    [
      :nickname,
      [:nickname, "Unknown", Random.rand(1..10)],
      [:nickname, "Unknown", Random.rand(10.99)]
    ]
  end

  def should_generate_new_friendly_id?
    nickname_changed? || slug.blank?
  end
end
