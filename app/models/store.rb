class Store 
    include Mongoid::Document
    attr_accessible :name, :avatar, :avatar_cache, :remove_avatar
    has_many :items, :dependent => :destroy
    belongs_to :user
    
    field :name
    field :active, type: Integer
    field :avatar
      
    mount_uploader :avatar, AvatarUploader
  
    
    def deactivate 
      self.active = 1
    end
    
    def activate 
      self.active = 0
    end
         
    def active?
      self.active == 1
    end
    
    def self.find_by_id_and_user(id, user)
      Store.where(user_id: user.id).find(id)
    end
end
