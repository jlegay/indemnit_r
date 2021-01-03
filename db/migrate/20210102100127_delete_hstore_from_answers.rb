class DeleteHstoreFromAnswers < ActiveRecord::Migration[6.0]
  def change
    remove_column :answers, :details
    add_column :answers, :open_to_indemnities, :boolean
  end
end
