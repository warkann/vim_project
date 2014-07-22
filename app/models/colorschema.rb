# == Schema Information
#
# Table name: colorschemas
#
#  id              :integer          not null, primary key
#  title           :string(255)      not null
#  body            :text             not null
#  user_id         :integer          not null
#  colorschema_img :string(255)      default("")
#  slug            :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Colorschema < ActiveRecord::Base
	include PgSearch
	multisearchable :against => [:title, :body]

	validates_presence_of :title
	validates_presence_of :body

	belongs_to :user

	mount_uploader :colorschema_img, ColorschemasImgUploader

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
