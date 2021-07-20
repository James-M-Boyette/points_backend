class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :company_id
      t.integer :point_amount
      t.string :timestamp

      t.timestamps
    end
  end
end
