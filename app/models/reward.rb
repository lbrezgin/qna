class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image
  validates :title, presence: true
  validate :image_presence_if_title_present

  private

  def image_presence_if_title_present
    if title.present? && !image.attached?
      errors.add(:image, "must be attached if title is present")
    end
  end
end
