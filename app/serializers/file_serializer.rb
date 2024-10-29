class FileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :url

  def url
    if Rails.env.development?
      object.url
    else
      rails_blob_path(object, only_path: true)
    end
  end
end
