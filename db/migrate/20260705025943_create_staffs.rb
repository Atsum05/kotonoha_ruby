class CreateStaffs < ActiveRecord::Migration[8.1]
  def change
    create_table :staffs do |t|
      t.string     :nombre, null: false
      t.string     :cargo, null: false
      t.references :staff_category, null: false, foreign_key: true
      t.integer    :position, default: 0, null: false
      t.string     :carrera
      t.date       :birth_date
      t.date       :university_start_date
      t.date       :kotonoha_start_date
      t.string     :correo
      t.string     :linkedin_url
      t.text       :interests

      t.timestamps
    end

    add_index :staffs, [ :staff_category_id, :position ]
  end
end
