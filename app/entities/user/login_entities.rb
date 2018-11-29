module User::LoginEntities
    class Session < ::Grape::Entity
        expose :status 
        expose :account ,if: lambda {|data,options|options[:status]=='success'}
        expose :token  ,if: lambda {|data,options|options[:status]=='success'}
        expose :error ,if: lambda {|data,options|options[:status]=='fails'}
    end
    class Register < ::Grape::Entity
        expose :status 
        expose :error ,if: lambda {|data,options|options[:status]=='fails'}
    end
end
