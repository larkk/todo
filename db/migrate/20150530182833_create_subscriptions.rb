class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :question, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end

    add_index :subscriptions, [:question_id, :user_id], unique: true
  end
end
