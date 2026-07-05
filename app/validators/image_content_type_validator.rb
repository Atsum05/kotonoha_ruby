## Validates that an Active Storage has_one_attached attribute, if attached,
## is one of the allowed image types.
##
## Usage: validates :photo, image_content_type: true
class ImageContentTypeValidator < ActiveModel::EachValidator
  ALLOWED_TYPES = %w[image/png image/jpeg image/webp].freeze

  def validate_each(record, attribute, value)
    return unless value.attached?

    unless value.content_type.in?(ALLOWED_TYPES)
      record.errors.add(attribute, "debe ser una imagen (PNG, JPEG o WEBP)")
    end
  end
end
