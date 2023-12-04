class AddMobileAddressToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :mobile, :integer
    add_column :users, :address, :string
  end
end
