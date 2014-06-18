# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  body       :string(255)      not null
#  user_id    :integer          not null
#  post_img   :string(255)      default("")
#  slug       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Post < ActiveRecord::Base
	validates_presence_of :title
	validates_presence_of :body

	belongs_to :user
	acts_as_taggable

	mount_uploader :post_img, PostsImgUploader

	extend FriendlyId
	friendly_id :slug_title, use: :slugged

	def slug_title
		[
			:title,
			[:title, Random.rand(1..10)],
			[:title, Random.rand(10.99)]
		]
	end

	def should_generate_new_friendly_id?
		title_changed? || slug.blank?
	end

end
