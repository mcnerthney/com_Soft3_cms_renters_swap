class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name
  field :admin
  field :avatar
  
  has_many :stores
  has_and_belongs_to_many :item_user_groups
    #has_many :items, :through => :item_accesses 
    
  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :avatar, :avatar_cache, :remove_avatar, :email, :password, :remember_me
  
  
  mount_uploader :avatar, AvatarUploader
  
end

