class CreatePayers < ActiveRecord::Migration[6.1]
  def change
    create_table :payers do |t|
      t.string :name
      t.integer :company_id
      t.integer :point_total

      t.timestamps
    end
  end
end
