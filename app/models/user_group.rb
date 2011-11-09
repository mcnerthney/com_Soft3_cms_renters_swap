class UserGroup

include Mongoid::Document 

field :everyone, Type:Boolean
field :all_fb_friends, Type:Boolean
field :name, Type:String

    
    
def name
  if self.everyone 
    "Everyone"
  elsif self.all_fb_friends
    s = "Your Facebook Friends"
  else
    "<List Of Renters>"
  end
end

has_and_belongs_to_many :users

def self.everyone
  UserGroup.find_or_create_by(everyone: true)
end

def self.all_fb_friends
  UserGroup.find_or_create_by(all_fb_friends: true)
end



end