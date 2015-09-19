class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :name
      t.belongs_to :poll, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
