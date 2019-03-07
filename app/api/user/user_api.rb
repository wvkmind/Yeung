module User::UserApi
    def self.included(api)
        api.namespace :user do 
            desc 'User list'
            get nil do
                a = User::User.all
                User::UserEntities::List.represent(a).as_json
            end
        end
    end
end