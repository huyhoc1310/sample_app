class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_mp, ->{order created_at: :desc}
  scope :feed, (lambda do |id|
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end)
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_max}
  validate :picture_size

  private

  def picture_size
    return unless picture.size > Settings.picture_size.megabytes
    errors.add :picture, "#{I18n.t('microposts.model.less_than')}
    #{Settings.picture_size}MB"
  end
end
