class AddReasonToAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :indemnity_reason, :string
  end
end
