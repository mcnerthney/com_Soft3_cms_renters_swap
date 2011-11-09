class FbFriend
    include Mongoid::Document
    
    field :access_token, type: String
    field :fb_id,        type: String
    field :endpoint,     type: String
    field :name,         type: String
    
    embedded_in :user
end