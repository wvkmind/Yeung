class User::Session < ApplicationRecord
    def self.update_session(account, token)
        session = User::Session.where('account = ?', account).take
        if session.nil?
            session = User::Session.create account: account, token:token
        elsif session.token.blank?
            session.update_attributes token: token
        end
        session
      end
end
