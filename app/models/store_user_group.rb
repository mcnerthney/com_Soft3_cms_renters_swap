class StoreUserGroup < UserGroup
    
    include Mongoid::Document 
    
    has_and_belongs_to_many :stores
    
    
end

