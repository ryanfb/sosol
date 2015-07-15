#Communities are designed to allow anyone to create their own set of boards and editorial review.
#The workflow and boards work the same as the standard SoSOL workflow with the exception that the finalized publications is not committed to canonical. Instead it is copied to the chosen end_user for the community.

class Community < ActiveRecord::Base
  
  has_many :communities_members
  has_many :members, :class_name => "User", :source => :user, :foreign_key => "community_id", :through => :communities_members
  has_many :communities_admins
  has_many :admins, :class_name => "User", :source => :user, :foreign_key => "community_id", :through => :communities_admins
  
  
  has_many :boards , :dependent => :destroy 
  has_many :publications
  
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name

  #The end_user is a sosol user to whom the communities' finalized publications are copied.
  def end_user
    if self.end_user_id.nil?
      return nil  
    end
      return User.find_by_id(self.end_user_id)
  end
  
  
  #Checks to see whether or not to allow members to submit to the community
  #
  #*Returns*
  #- true if the community is setup properly to receive submissions
  #- false if community should not be submitted to
  def is_submittable?
    #if there is nowhere for the final publication to go, don't let them submit
    #if there are no boards to review the publication, don't let them submit
    return !self.end_user.nil? && (self.boards && self.boards.length > 0)
  end
  
  #*Returns* 
  #- a standard format for the community name and friendly_name.
  #Used to ensure consistency throughout pages.
  def format_name
    return  self.name + " ( " + self.friendly_name + " )"
  end

  #*Returns*
  # - true if the community is setup to allow self signup
  # - false if the communit is not setup to allow self signup
  def allows_self_signup?
    return self.allows_self_signup.nil? ? false : allows_self_signup
  end

  # Adds a user as a member of this community
  # 
  # *Returns*
  #  - true if successful or user is alreadya a member
  #  - false if unsuccessful
  def add_member(user_id)
    user = User.find_by_id(user_id.to_s)
    if user.nil? 
      return false
    end
    if nil == self.members.find_by_id(user.id) 
      self.members << user
      self.save
    end
    return true
  end
end
