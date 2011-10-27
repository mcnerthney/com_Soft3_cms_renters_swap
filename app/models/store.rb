class Store 
    include Mongoid::Document
    attr_accessible :name
    has_many :items, :dependent => :destroy
    belongs_to :user
    
    field :name
    field :active
    
    def deactivate 
      self.active = false
    end
    
    def activate 
      self.active = true
    end
         
    def active?
      self.active
    end
    
    def self.find_by_id_and_user(id, user)
      Store.where(user_id: user.id).find(id)
    end
end
