class FixVotesUserIdToInteger < ActiveRecord::Migration
  def self.up
    if ActiveRecord::Base.connection.adapter_name.downcase.include? 'postgresql'
      change_column :votes, :user_id, 'integer USING (user_id::integer)'
    else
      change_column :votes, :user_id, :integer
    end
  end

  def self.down
  	change_column :votes, :user_id, :string
  end
end
