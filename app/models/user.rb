# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  email               :string(255)      default(""), not null
#  encrypted_password  :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  admin               :boolean          default(FALSE)
#  slug                :string(255)      not null
#  nickname            :string(255)      not null
#  user_img            :string(255)      default("")
#  created_at          :datetime
#  updated_at          :datetime
#  access_code         :integer          default(1)
#

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

  ROLES = [["Admin", 111], ["Moderator", 110], ["User", 100]]
end
