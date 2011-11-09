class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :confirmable, :omniauthable,:recoverable, :rememberable, :trackable, :validatable

  field :name
  field :admin
  field :avatar
  field :email
  field :fb_auth_token, type:String
  field :fb_id , type:String
  field :fb_avatar_url, type:String
    
  field :fb_updated_at, type: DateTime
    
  embeds_many :fb_friends
  
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
      #todo - set user so it's already confirmed
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

def set_fb_data
 
    if  self.fb_auth_token != nil? 
      begin         
        me = FbGraph::User.me(self.fb_auth_token)
        me = me.fetch
        
        self.fb_id         = me.identifier
        self.fb_avatar_url = me.picture
        self.name          = me.name
        self.fb_friends.clear
        me.friends.each do |friend|
            
            f = FbFriend.new
            f.access_token = friend.access_token
            f.fb_id        = friend.identifier
            f.name         = friend.name
            f.endpoint     = friend.endpoint
            self.fb_friends.push(f)
            
        end
        self.fb_updated_at = DateTime.now()
        self.save
        return
       rescue FbGraph::InvalidToken
      end
   end  
   self.fb_auth_token = nil
   self.fb_id = nil
   self.fb_avatar_url = nil
   self.fb_friends.clear
   self.fb_updated_at = DateTime.now()
   self.save        



    
end

def fb_friend_count
    User.where('fb_friends.fb_id' => self.fb_id).size
end


  
end

