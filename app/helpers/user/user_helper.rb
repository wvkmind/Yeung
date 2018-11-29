module User::UserHelper
    def self.login(account, password)
        raise Exception.new('Account or password not provied.') if account.blank? or password.blank?
        user = User::User.where('account=?', account).take
        raise Exception.new('Account doesnot exists.') if user.nil?
        
        hashed_password = hash_password password, user.salt
        if bytes_equal? hashed_password.bytes, Base64.decode64(user.hashed_password).bytes
          token = SecureRandom.uuid
          User::Session.update_session(account, token)
        else
          raise Exception.new('Wrong password.')
        end
    end

    def self.generate_password(password)
        salt = generate_salt
        {salt:salt,hash_password:hash_password(password, salt)}
    end
    private

    def self.generate_salt
        SecureRandom.base64(16)
    end

    def self.hash_password(pass, salt)
        digest = Digest::SHA256.new
        digest.reset
        digest.update(Base64.decode64(salt))
        
        hashed = digest.update(pass).digest
        
        for i in 1..1023
          digest.reset
          digest.update(hashed)
          hashed = digest.digest
        end
      
        hashed
    end
  
    def self.bytes_equal?(a, b)
        ret = a.size == b.size
        a.each_with_index {|aa, i| ret &= aa == b[i]}
        ret
    end
end
  