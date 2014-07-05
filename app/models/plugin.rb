# == Schema Information
#
# Table name: plugins
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  description :string(255)      not null
#  link        :string(255)      not null
#  user_id     :integer          not null
#  slug        :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#  popularity  :integer          default(0)
#

class Plugin < ActiveRecord::Base
	include PgSearch
	multisearchable :against => [:title, :description]

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

	private

	# метод, отвечающий за рейтинг плагина
  def self.vote(plugin, current_user)

    # увеличиваем на 1 рейтинг плагина и записываем в массив id текущего пользователя только один раз
    unless current_user.plugin_id.include?(plugin.id)
      plugin.increment!(:popularity)
      current_user.plugin_id += [plugin.id]
    end

    current_user.save
   end
end
