class ApplicationController < ActionController::Base
  protect_from_forgery
    
    before_filter :set_fb_env
    
    def set_fb_env
      if Rails.env.production?   
        @fb_api_key = '248876391827927'
      else
        @fb_api_key = '196690723742630'
      end
    end

    #    def authenticate_user!
    #    if !current_user
            # This should work, but session is lost. See https://github.com/plataformatec/devise/issues/1357
            # session[:return_to] = request.fullpath
    #        redirect_to user_omniauth_authorize_path(:facebook, :origin => request.fullpath)
    #    end
    #end   
    
    def after_sign_in_path_for(resource)
        # This should work, but session is lost. See https://github.com/plataformatec/devise/issues/1357
        # return_to = session[:return_to]
        # session[:return_to] = nil
        return_to = request.env['omniauth.origin']
        stored_location_for(resource) || return_to || root_path  
    end 
    
    
    
    def has_access(item)
     i = item
     access= 0
    
    
      if user_signed_in? && 
         ( current_user.admin? || i.store.user == current_user )
          #logger.debug "admin or current user"
          access = 1
      else
        if i.item_user_groups.where(everyone: true).first.nil?      
    
          if i.item_user_groups.where(all_fb_friends: true).first.nil?
    
           access = 0   
              #logger.debug "no vaild user groups  #{i.store.user.email}"
    
          else
           if !user_signed_in?
               access = -1
               #logger.debug "fb friend - without signin"
               return
           end
           
           # must be in one of the owner's fb_friends.           
           if  current_user.fb_id.nil? 
               #logger.debug "fb friend - without current_user.fb_id"
           else
             if i.store.user.nil? || i.store.user.fb_friends.where(fb_id: current_user.fb_id).first.nil?
               access = 0
                 #logger.debug "fb friend no access #{i.id}"           
             else
               # current user is a friend of the store's owner
               access = 1
               #logger.debug "fb friend access #{i.id}"
             end
          end
       end
    else
          # everyone
          access = 1
            #logger.debug "everyone access #{i.id}"
    end
end
access
end


end
