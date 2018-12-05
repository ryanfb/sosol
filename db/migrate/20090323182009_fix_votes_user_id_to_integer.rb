class FixVotesUserIdToInteger < ActiveRecord::Migration
  def self.up
    begin
      change_column :votes, :user_id, :integer
    rescue
      change_column :votes, :user_id, 'integer USING user_id::integer'
    end
  end

  def self.down
  	change_column :votes, :user_id, :string
  end
end
