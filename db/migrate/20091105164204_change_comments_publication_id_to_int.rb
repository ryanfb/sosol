class ChangeCommentsPublicationIdToInt < ActiveRecord::Migration
  def self.up
    if ActiveRecord::Base.connection.adapter_name.downcase.include? 'postgresql'
      change_column :comments, :publication_id, 'integer USING (publication_id::integer)'
    else
      change_column :comments, :publication_id, :integer
    end
  end

  def self.down
    change_column :comments, :publication_id, :string
  end
end
