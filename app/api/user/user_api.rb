module User::UserApi
    def self.included(api)
        api.namespace :user do 
            desc 'User list'
            get nil do
                ps = User::UserHelper.generate_password(params[:password])
                user = User::User.create({
                    account:"admin",
                    hashed_password:ps[:hash_password].to_s,
                    salt:ps[:salt].to_s
                })
                User::LoginEntities::Register.represent(user).as_json
            end
        end
    end
end