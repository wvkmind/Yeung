module User::LoginEntities
    class Session < ::Grape::Entity
        expose :account 
        expose :token
    end
    class Register < ::Grape::Entity
        expose :id 
    end
end
