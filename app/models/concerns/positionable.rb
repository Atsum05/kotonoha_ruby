## Gives a model a manually-orderable `position` column, with move_up/move_down
## helpers that swap position with the adjacent record. New records
## auto-assign the next position at the end of their scope on create.
##
## Usage:
##   include Positionable                  # single global ordering
##   include Positionable
##   positioned_within :staff_category_id  # ordering scoped per category
module Positionable
  extend ActiveSupport::Concern

  included do
    before_validation :assign_next_position, on: :create
  end

  class_methods do
    def positioned_within(scope_column)
      @position_scope_column = scope_column
    end

    def position_scope_column
      @position_scope_column
    end
  end

  def move_up
    swap_with(siblings.where("position < ?", position).order(position: :desc).first)
  end

  def move_down
    swap_with(siblings.where("position > ?", position).order(position: :asc).first)
  end

  private

  def siblings
    scope_column = self.class.position_scope_column
    return self.class.all unless scope_column

    self.class.where(scope_column => self[scope_column])
  end

  def assign_next_position
    return if position.present?

    self.position = (siblings.maximum(:position) || -1) + 1
  end

  def swap_with(other)
    return unless other

    self.class.transaction do
      my_position = position
      update_column(:position, other.position)
      other.update_column(:position, my_position)
    end
  end
end
