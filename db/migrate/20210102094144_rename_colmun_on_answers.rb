class RenameColmunOnAnswers < ActiveRecord::Migration[6.0]
  def change
    remove_column :answers, :open_to_indemnities
    add_column :answers, :details, :hstore
  end
end
