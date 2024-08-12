class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: { allow_blank: true }

  def gist?
    self.url.include?("gist.github.com")
  end

  def get_id_from_url(url)
    url.split("/").last
  end
end
