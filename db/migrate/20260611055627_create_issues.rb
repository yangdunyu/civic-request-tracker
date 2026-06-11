class CreateIssues < ActiveRecord::Migration[7.2]
  def change
    create_table :issues do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :category, null: false, default: 4
      t.integer :status, null: false, default: 0
      t.integer :priority, null: false, default: 1
      t.string :location, null: false
      t.string :contact_email, null: false
      t.text :ai_summary
      t.string :ai_suggested_category
      t.references :assigned_to, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :issues, :status
    add_index :issues, :category
  end
end
