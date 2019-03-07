module User::LoginApi
    def self.included(api)
        api.namespace :user_login do 
            desc 'Register'
            params do
                requires :account, type: String, desc: '用户名.'
                optional :password, type: String, desc: '密码.'
            end
            post '/register' do
                begin
                    raise 'Not Admin.' if(!User::User.current.is_admin?)
                    user = nil
                    if(params[:id].blank?)
                        user = User::User.new
                        user[:account]=params[:account]
                    else 
                        user = User::User.find_by_id(params[:id])
                    end
                    if(params[:status]==0)
                        ps = User::UserHelper.generate_password(params[:password])
                        user[:hashed_password]=ps[:hash_password].to_s
                        user[:salt]=ps[:salt].to_s
                    end
                    user[:status]=params[:status]
                    user.save
                    User::LoginEntities::Register.represent(user).as_json
                rescue => exception
                    error!(exception.message,403)
                end
            end
            desc 'Login'
            params do
                requires :user_name, type: String, desc: '用户名.'
                requires :password, type: String, desc: '密码.'
            end
            post '/login' do
                begin
                    session = User::UserHelper::login params[:user_name], params[:password]
                    session[:token] = Base64.encode64("#{session.account}:#{session.token}").gsub("\n", '').strip
                    User::LoginEntities::Session.represent(session).as_json
                rescue => exception
                    error!(exception.message,403)
                end
            end
        end
    end
end