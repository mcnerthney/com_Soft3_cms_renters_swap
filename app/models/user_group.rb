class UserGroup

include Mongoid::Document 

field :everyone, Type:Boolean
field :all_renters, Type:Boolean
field :all_fb_friends, Type:Boolean
field :name, Type:String

def name
if self.everyone 
"Everyone"
elsif self.all_renters
"All RentersSwappers"
elsif self.all_fb_friends
"Your Facebookers"
else
"<List Of Renters>"
end
end

has_and_belongs_to_many :users

def self.everyone
  return UserGroup.find_or_create_by(everyone: true)
end

def self.all_renters
  return UserGroup.find_or_create_by(all_renters: true)
end

def self.all_fb_friends
  return UserGroup.find_or_create_by(all_fb_friends: true)
end

end

