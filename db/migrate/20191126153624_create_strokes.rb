class CreateStrokes < ActiveRecord::Migration[5.2]
  def change
    create_table :strokes do |t|
      t.string :room_id, null: false
      t.string :prevx, null: false
      t.string :prevy, null: false
      t.string :currx, null: false
      t.string :curry, null: false
      t.string :width, null: false
      t.string :color, null: false

      t.timestamps
    end
  end
end
