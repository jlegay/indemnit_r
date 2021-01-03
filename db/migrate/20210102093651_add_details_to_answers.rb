class AddDetailsToAnswers < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'hstore'
    remove_column :answers, :indemnity_reason
    remove_column :answers, :open_to_indemnities
    add_column :answers, :open_to_indemnities, :hstore
  end
end
