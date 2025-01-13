class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :dob, :date
    add_column :users, :address, :text
    add_column :users, :mobile_number, :string
    add_column :users, :gender, :string
  end
end
