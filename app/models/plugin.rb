class Plugin < ActiveRecord::Base
	validates_presence_of :title
	validates_presence_of :description
	validates_presence_of :link

	belongs_to :user
	acts_as_taggable

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
