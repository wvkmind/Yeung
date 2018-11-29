module User::LoginApi
    def self.included(api)
        api.namespace :user_login do 
            desc 'Register'
            params do
                requires :user_name, type: String, desc: '用户名.'
                requires :password, type: String, desc: '密码.'
            end
            post '/register' do
                begin
                    ps = User::UserHelper.generate_password(params[:password])
                    User::User.create({
                        account:params[:user_name],
                        hashed_password:ps[:hash_password],
                        salt:ps[:salt]
                    })
                    User::LoginEntities::Session.represent(session,{status: 'success'}).as_json
                rescue Exception => e
                    User::LoginEntities::Session.represent(session,{status: 'fails'}).as_json
                end
            end
            desc 'Login'
            params do
                requires :user_name, type: String, desc: '用户名.'
                requires :password, type: String, desc: '密码.'
            end
            post '/login' do
                begin
                    session = User::UserHelper::login params[:account], params[:password]
                    token = Base64.encode64("#{session.account}:#{session.token}").gsub("\n", '').strip
                    User::LoginEntities::Session.represent(session,{status: 'success',token: token}).as_json
                rescue Exception => e
                    User::LoginEntities::Session.represent(session,{status: 'fails',error: e.message}).as_json
                end
            end
        end
    end
end