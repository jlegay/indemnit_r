class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.string :answer_text
      t.string :dependency
      t.boolean :final_answer
      t.boolean :open_to_indemnities
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
