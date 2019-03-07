module User::UserEntities
    class List < ::Grape::Entity
        expose :id,:account,:status,:created_at,:updated_at
    end
end
