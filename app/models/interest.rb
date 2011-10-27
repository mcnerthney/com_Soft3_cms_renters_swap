class Interest
  include Mongoid::Document
  attr_accessible :email
 
  field :email 
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, :presence   => true,
                    :format     => { :with => email_regex }
  validates_uniqueness_of :email, :case_sensitive => false                  
   
end
