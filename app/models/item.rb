class Item 
  include Mongoid::Document
    attr_accessible :title, :description, :active, :location, :cost, :item_user_groups
  belongs_to :store
  field :title
  field :description
  field :active, type: Integer
  field :location
  field :cost
    
  has_and_belongs_to_many :item_user_groups, :class_name => "UserGroup" 

  
  belongs_to :zipcode, :inverse_of => nil
  embeds_many :photos  

  validates :title,  :presence => true,
                     :length   => { :maximum => 150 }
  validates :description, :presence => true

  before_save   :set_zipcode
    
    
  def set_default_access
    self.item_user_groups = [ UserGroup.all_fb_friends ]  
  end
    
  def set_zipcode
      # TODO: regex and find zipcode from address
      self.zipcode = Zipcode.where(name: self.location).first
       
  end
  
  def latlon
     set_zipcode
     if ( !self.zipcode.nil? )
       return self.zipcode.location
     end
     nil
  end
  
  def deactivate 
     self.active = 0
   end
   
   def activate 
     self.active = 1
   end
        
   def active?
     self.active == 1
   end
  
    
    def to_json
        result = Hash.new
        result[:id]          = self.id
        result[:title]       = self.title
        result[:description] = self.description
        result[:latlon]      = self.latlon
        result[:cost]       = self.cost
     
        result.to_json
    end
    
 end  


