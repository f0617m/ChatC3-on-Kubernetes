class User < ApplicationRecord
  mount_uploader :image_name, ImgUploader
  has_secure_password
  has_secure_token

  validates :user_id, presence: true, uniqueness: {message: 'このユーザーIDは既に使用されています'}
  validates :name, presence: true
  validates :image_name, presence: true
  validates :password_digest, presence: true
  validates :token, uniqueness: true

end
