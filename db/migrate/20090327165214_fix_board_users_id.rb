class FixBoardUsersId < ActiveRecord::Migration
  def self.up
    if ActiveRecord::Base.connection.adapter_name.downcase.include? 'postgresql'
      change_column :boards_users, :board_id, 'integer USING (board_id::integer)'
    else
      change_column :boards_users, :board_id, :integer
    end
  end

  def self.down
  		change_column :boards_users, :board_id, :string  
  end
end
