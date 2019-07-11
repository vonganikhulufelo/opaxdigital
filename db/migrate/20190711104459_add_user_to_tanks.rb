class AddUserToTanks < ActiveRecord::Migration[5.2]
  def change
    add_reference :tanks, :user, foreign_key: true
  end
end
