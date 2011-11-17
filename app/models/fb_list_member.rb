class FbListMember
    include Mongoid::Document
    
    field :access_token, type: String
    field :fb_id,        type: String
    field :endpoint,     type: String
    field :name,         type: String
    
    embedded_in :fm_friend_list
end