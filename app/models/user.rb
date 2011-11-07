class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :confirmable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name
  field :admin
  field :avatar
  field :email
  field :fb_auth_token
  
  has_many :stores
    
  has_and_belongs_to_many :user_groups
    
  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :avatar, :avatar_cache, :remove_avatar, :email, :password, :remember_me
  
  
  mount_uploader :avatar, AvatarUploader
    
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    
    logger.debug "Facebook User data: #{data.inspect}"
    
    if user = User.find_by_email(data["email"])
      user
    else
      User.create(:email => data["email"], :name => data["name"], :password => Devise.friendly_token[0,20]) 
    end
  end

  def self.new_with_session(params, session)
   super.tap do |user|
    if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
    end
   end
  end

  def self.find_by_email(params)
    User.where(email: params).first
  end


  
end

