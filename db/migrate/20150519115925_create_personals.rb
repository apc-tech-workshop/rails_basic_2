class CreatePersonals < ActiveRecord::Migration
  def change
    create_table :personals do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
