class AddDefaultValueToAnswers < ActiveRecord::Migration[6.0]
  def change
    remove_column :answers, :open_to_indemnities
    add_column :answers, :open_to_indemnities, :boolean, default: :false
  end
end
