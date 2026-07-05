class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string   :title, null: false
      t.text     :description
      t.datetime :event_date, null: false
      t.string   :location
      t.integer  :capacity # nil = unlimited
      t.string   :form_url
      t.bigint   :organizer_id # will reference users once auth exists
      t.integer  :status, default: 0, null: false # draft / published / cancelled
      t.boolean  :hidden, default: false, null: false

      t.timestamps
    end

    add_index :events, :event_date
    add_index :events, :hidden
    add_index :events, :organizer_id
  end
end
