class CreateGroupMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :group_members do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.integer :member_type
      t.date :expiration_date
      t.integer :visit_count, default: 0

      t.timestamps
    end
  end
end
