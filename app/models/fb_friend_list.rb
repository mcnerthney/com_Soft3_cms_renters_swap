class FbFriendList
    include Mongoid::Document
    
    field :access_token, type: String
    field :fb_id,        type: String
    field :endpoint,     type: String
    field :name,         type: String
    
    embedded_in :user
    
    embeds_many :fb_list_members
    
    
    
end