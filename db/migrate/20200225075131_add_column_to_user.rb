class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :unique_user_id, :integer
    add_column :users, :public_email, :string, default: ""
    add_column :users, :commit_email, :string, default: ""
    add_column :users, :skype, :string, default: ""
    add_column :users, :linkedin, :string, default: ""
    add_column :users, :twitter, :string, default: ""
    add_column :users, :website_url, :string, default: ""
    add_column :users, :location, :string, default: ""
    add_column :users, :organization, :string, default: ""
    add_column :users, :bio, :text, default: ""
    add_column :users, :private_profile, :boolean, default: false
    add_column :users, :private_contributions, :boolean, default: false
    add_index :users, :unique_user_id,         unique: true
    add_column :users, :avatar, :string, default: ""
  end
end
