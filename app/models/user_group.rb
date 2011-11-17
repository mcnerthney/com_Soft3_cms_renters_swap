class UserGroup

include Mongoid::Document 

field :everyone, Type:Boolean
field :all_fb_friends, Type:Boolean
field :fb_friend_list, Type:Boolean



def name
  if self.everyone 
    "Everyone"
  elsif self.all_fb_friends
    s = "Your Facebook Friends"
  elsif self.fb_friend_list
    s = "Facebook List"
  else
    s = "Renters List"
  end
end

def self.everyone
  UserGroup.find_or_create_by(everyone: true)
end

def self.all_fb_friends
  UserGroup.find_or_create_by(all_fb_friends: true)
end



end