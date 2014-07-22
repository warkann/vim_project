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
#  plugin_id           :integer          default([]), is an Array
#  hack_id             :integer          default([]), is an Array
#  provider            :string(255)
#  uid                 :string(255)
#  name                :string(255)
#

class User < ActiveRecord::Base

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

  def self.build_plugins_list(current_user)
    list_of_user_plugins = Hash.new
    current_user.plugin_id.each do |id|
      if Plugin.where('id = ?', id ).exists?
        user_plugin = Plugin.find(id)
        # выдает корректные линки для исходных линков типа "https://github.com/..." и "github.com/". Для не подходящих по формату будет выдан NilClass
        correct_link = Plugin.find(id).link.sub!(/\A[https:\/\/]*[github.com\/]{11}/, "")
        # хэш состоящий из (объект модели Plugin => корректная ссылка)
        list_of_user_plugins.update( user_plugin => correct_link )
      end
    end
    return list_of_user_plugins
  end

  def self.build_user_directory(current_user)
    # создаем директорию для хранение дотфайлов рассортированных по юзерам. Выполнится однократно
    Dir.mkdir("public/users_dotfiles") unless Dir.exist?("public/users_dotfiles")
    # создаем личную папку юзера, если она еще не созданна
    if current_user.email != ""
      Dir.mkdir("public/users_dotfiles/user_#{current_user.email}") unless Dir.exist?("public/users_dotfiles/user_#{current_user.email}")
    else
      Dir.mkdir("public/users_dotfiles/user_#{current_user.uid}") unless Dir.exist?("public/users_dotfiles/user_#{current_user.uid}")
    end
  end

  def self.file_exist?(current_user)
    # проверяем, существует ли создаваемый файл. Нужно для защиты от многократного создания одинаковых файлов. Создать файл можно каждую минуту.
    if current_user.email != ""
      File.exist?("public/users_dotfiles/user_#{current_user.email}/#{Time.now.strftime("%d_%m_%Y_%H_%M")}_#{current_user.email}_dotfile.vimrc")
    else
      File.exist?("public/users_dotfiles/user_#{current_user.uid}/#{Time.now.strftime("%d_%m_%Y_%H_%M")}_#{current_user.uid}_dotfile.vimrc")
    end
  end

  def self.build_user_dotfile(current_user)
    # создаем файл конфигурации с временной меткой. Создать можно раз в минуту. Флаг "w+" перезаписывает содержимое
    if current_user.email != ""
      dotfile = File.new("public/users_dotfiles/user_#{current_user.email}/#{Time.now.strftime("%d_%m_%Y_%H_%M")}_#{current_user.email}_dotfile.vimrc", "w+")
    else
      dotfile = File.new("public/users_dotfiles/user_#{current_user.uid}/#{Time.now.strftime("%d_%m_%Y_%H_%M")}_#{current_user.uid}_dotfile.vimrc", "w+")
    end
    #создаем содержимое файла
    current_user.plugin_id.each do |id|
      if Plugin.where('id = ?', id ).exists?
        # выдает корректные линки для исходных линков типа "https://github.com/..." и "github.com/". Для не подходящих по формату будет выдан NilClass
        config = Plugin.find(id).link.sub!(/\A[https:\/\/]*[github.com\/]{11}/, "")
        if config != nil
          #пишем в созданный файл нужную информацию и отсылаем файл.
          File.open(dotfile, 'a+'){|file| file.write "NeoBundle '#{config}'\n"}
        end
      end
    end
    return dotfile
  end

  def self.create_with_omniauth(auth)
    user = User.new
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.slug = ''
      user.nickname = ''
      user.access_code = 100
      user.save(validate: false)
      user
  end
end