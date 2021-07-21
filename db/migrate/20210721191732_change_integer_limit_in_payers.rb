class ChangeIntegerLimitInPayers < ActiveRecord::Migration[6.1]
  def change
    change_column :payers, :company_id, :integer, limit: 8
  end
end
