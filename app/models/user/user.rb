class User::User < ApplicationRecord
    def self.current
        @current_user
    end
    
    def self.current=(user)
        @current_user = user
    end

    def is_admin?
        account=='admin'
    end

    def deleted?
        status!=0
    end
    
    def permission
        p = {}
        p.merge!({user:true})if(is_admin?)
        p
    end
end
