class UserGroup

 include Mongoid::Document 

 field :public, Type:Boolean
 field :all_renters, Type:Boolean
 field :all_fb_friends, Type:Boolean

 has_and_belongs_to_many :items

 def name
    if self.public 
       "Everyone"
    elsif self.all_renters
       "All RentersSwappers"
    elsif self.all_fb_friends
       "Your Facebookers"
    else
       "<List Of Renters>"
    end
 end

 #selected renters users
 has_and_belongs_to_many :users



end

