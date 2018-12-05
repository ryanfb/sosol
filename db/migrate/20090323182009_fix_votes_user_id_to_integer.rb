class FixVotesUserIdToInteger < ActiveRecord::Migration
  def self.up
    begin
      change_column :votes, :user_id, :integer
    rescue
      change_column :votes, :user_id, 'integer USING CAST(user_id AS integer)'
    end
  end

  def self.down
  	change_column :votes, :user_id, :string
  end
end
