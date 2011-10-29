class Item 
  include Mongoid::Document
    attr_accessible :title, :description, :active, :zipcode_name
  belongs_to :store
  field :title
  field :description
  field :active
  field :zipcode_name
  
  belongs_to :zipcode, :inverse_of => nil
  embeds_many :photos  

  validates :title,  :presence => true,
                     :length   => { :maximum => 150 }
  validates :description, :presence => true
    
  before_save :set_zipcode
    
  def set_zipcode

      self.zipcode = Zipcode.where(name: self.zipcode_name).first
       
  end
  
  def location
     set_zipcode
     if ( !self.zipcode.nil? )
       return self.zipcode.location
     end
     nil
  end
  
  def deactivate 
     self.active = false
   end
   
   def activate 
     self.active = true
   end
        
   def active?
     self.active
   end
  
    
    def to_json
        result = Hash.new
        result[:id]          = self.id
        result[:title]       = self.title
        result[:description] = self.description
        result[:zipname]     = self.zipcode_name
        result[:location]    = self.location
    
        
        result.to_json
    end
end
