class ChangeEmailersUsersEmailerIdToInteger < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.adapter_name.downcase.include? 'postgresql'
      change_column :emailers_users, :emailer_id, 'integer USING (emailer_id::integer)'
    else
      change_column :emailers_users, :emailer_id, :integer
    end
  end

  def down
    change_column :emailers_users, :emailer_id, :string  
  end
end
