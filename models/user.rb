require './db/mysql_connector.rb'

class User 
	attr_reader :id, :username, :email, :bio

    def initialize(params)
        @id = params["id"]
        @username = params["username"]
        @email = params["email"]
        @bio = params["bio"]
    end

    def save
        return false unless valid?
        client = create_db_client
        client.query("INSERT INTO Users (username, email, bio) VALUES ('#{username}', '#{email}', '#{bio}')")
        user_id = client.query("SELECT LAST_INSERT_ID() AS id")
        user_id.any? {|data| return data["id"]}
    end

    def exist?
        client = create_db_client
        exist = client.query("SELECT id FROM Users WHERE email = '#{email}' OR username = '#{username}'")
        return true if exist.any?
        false
    end

    def valid?
        return false if @username.nil? || @email.nil? || exist?
        true
    end
end