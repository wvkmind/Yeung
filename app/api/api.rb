class API < Grape::API
    version 'v1', :using => :path, :vendor => 'yeung'
    format :json
    prefix :api
    include EntitiesBoot
    include User::LoginApi
    include User::UserApi
    include User::PermissionApi
    SKIP_AUTH = Set.new([
        "/api/v1/user_login/login"
    ])
    helpers do
        def check_user_session
            token = params[:token]
            if token.nil?
                begin
                    token = request.headers.fetch('Authorization')
                    params[:token] = token
                rescue => e
                    Rails.logger.info(e.message)
                end
            end
            if token.nil?
                return false
            end
            token = Base64.decode64 token
            account, id = token.split(':')
            session = User::Session.exists?(['account=? and token=?', account, id])
            unless session.blank?
                User::User.current = (User::User.find_by_account(account) rescue nil)
                return true
            else
                User::User.current = nil
                return false
            end
        end
    end
    before do

        unless SKIP_AUTH.include?(request.path)
        
            if check_user_session
                
            else
                render json: {status: 'FAILURE', error: 'NOTLOGIN'}
            end

        end

    end
end