class CreateStaffCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :staff_categories do |t|
      t.string  :name, null: false
      t.integer :position, default: 0, null: false

      t.timestamps
    end

    add_index :staff_categories, :name, unique: true
    add_index :staff_categories, :position
  end
end
