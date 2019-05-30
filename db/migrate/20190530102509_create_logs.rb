class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
    	t.string :description
      t.string :uid
      t.string :username
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
