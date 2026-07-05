class StaffCategory < ApplicationRecord
  include Positionable

  has_many :staffs, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:position) }
end
