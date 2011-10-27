class Item 
  include Mongoid::Document
  attr_accessible :title, :description, :active, :location
  belongs_to :store
  field :title
  field :description
  field :active
  field :location
  
  validates :title,  :presence => true,
                     :length   => { :maximum => 150 }
  validates :description, :presence => true
  
  def deactivate 
     self.active = false
   end
   
   def activate 
     self.active = true
   end
        
   def active?
     self.active
   end
  
end
