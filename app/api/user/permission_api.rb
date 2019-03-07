module User::PermissionApi
    def self.included(api)
        api.namespace :permission do 
            desc 'Button list'
            get '/button_list' do
                User::User.current.permission
            end
        end
    end
end