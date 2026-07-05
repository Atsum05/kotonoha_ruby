class ChangePositionDefaultsOnStaffTables < ActiveRecord::Migration[8.1]
  def change
    # nil (not 0) means "not yet assigned", so the auto-position callbacks can
    # tell an explicit position: 0 apart from one nobody set.
    change_column_default :staff_categories, :position, from: 0, to: nil
    change_column_null :staff_categories, :position, true

    change_column_default :staffs, :position, from: 0, to: nil
    change_column_null :staffs, :position, true
  end
end
