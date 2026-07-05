class Staff < ApplicationRecord
  include Positionable
  positioned_within :staff_category_id

  belongs_to :staff_category

  has_one_attached :photo

  validates :nombre, presence: true
  validates :cargo, presence: true
  validates :correo, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :linkedin_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true
  validates :photo, image_content_type: true

  scope :ordered, -> { eager_load(:staff_category).order("staff_categories.position", :position, :nombre) }

  def edad
    years_since(birth_date)
  end

  def anos_en_la_u
    years_since(university_start_date)
  end

  def tiempo_en_kotonoha
    return nil unless kotonoha_start_date

    total_months = (Date.current.year - kotonoha_start_date.year) * 12 +
                   (Date.current.month - kotonoha_start_date.month)
    total_months -= 1 if Date.current.day < kotonoha_start_date.day
    total_months = 0 if total_months.negative?

    years, months = total_months.divmod(12)
    parts = []
    parts << "#{years} año#{'s' if years != 1}" if years.positive?
    parts << "#{months} mes#{'es' if months != 1}" if months.positive?
    parts.join(", ").presence || "Menos de un mes"
  end

  private

  def years_since(date)
    return nil unless date

    today = Date.current
    today.year - date.year - (today.strftime("%m%d") < date.strftime("%m%d") ? 1 : 0)
  end
end
