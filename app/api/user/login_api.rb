module User::LoginApi
    def self.included(api)
        api.namespace :user_login do 
            desc 'Register'
            params do
                requires :user_name, type: String, desc: '用户名.'
                requires :password, type: String, desc: '密码.'
            end
            post '/register' do
                ps = User::UserHelper.generate_password(params[:password])
                user = User::User.create({
                    account:"admin",
                    hashed_password:ps[:hash_password].to_s,
                    salt:ps[:salt].to_s
                })
                User::LoginEntities::Register.represent(user).as_json
            end
            desc 'Login'
            params do
                requires :user_name, type: String, desc: '用户名.'
                requires :password, type: String, desc: '密码.'
            end
            post '/login' do
                begin
                    session = User::UserHelper::login params[:user_name], params[:password]
                rescue => exception
                    error!(exception.message,403)
                end
                session[:token] = Base64.encode64("#{session.account}:#{session.token}").gsub("\n", '').strip
                User::LoginEntities::Session.represent(session).as_json
            end
  
        end
    end
end