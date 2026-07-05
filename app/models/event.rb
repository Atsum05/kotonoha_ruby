class Event < ApplicationRecord
  has_one_attached :image

  enum :status, { draft: 0, published: 1, cancelled: 2 }

  validates :title, presence: true
  validates :event_date, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :form_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true
  validates :image, image_content_type: true

  scope :upcoming, -> { where("event_date >= ?", Time.current).order(event_date: :asc) }
  scope :past, -> { where("event_date < ?", Time.current).order(event_date: :desc) }
  scope :visible, -> { where(hidden: false) }
  scope :hidden_only, -> { where(hidden: true) }

  def unlimited_capacity?
    capacity.nil?
  end

  def past?
    event_date < Time.current
  end
end
