class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
    	t.references :user, index: true
    	t.string :secret
    	t.string :token
    end
    add_foreign_key :authorizations, :users
  end
end
