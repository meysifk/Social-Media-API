require './db/mysql_connector'
require './models/hashtag'

class Comment

	attr_reader :id, :content, :file, :user_id, :post_id, :hashtags

	def initialize(params)
		@id = params["id"]
		@content = params["content"]
		@file = params["file"]
		@user_id = params["user_id"]
        @post_id = params["post_id"]
		@hashtags = params["content"] ? params["content"].scan(/#\w+/).flatten.to_set : nil
	end

	def save
        return false unless valid?

        client = create_db_client
        client.query("INSERT INTO Comments (content, file, user_id, post_id) VALUES ('#{content}', '#{file}', #{user_id}, #{post_id})")
        rawData = client.query("SELECT LAST_INSERT_ID() AS id")
        comment_id = Comment.convert_to_array(rawData)[0].id

		unless hashtags.empty?
			hashtags_id = Array.new
            for hashtag_name in hashtags do
                hashtag_id = Hashtag.find_by_name(hashtag_name)
                unless hashtag_id.nil?
                    hashtags_id << hashtag_id.id
                else
                    hashtag = Hashtag.new({'name' => hashtag_name})
                    hashtags_id << hashtag.save
                end
            end
            for id in hashtags_id do
                client.query("INSERT INTO Comment_Hashtags (hashtag_id, comment_id) VALUES (#{id}, #{comment_id})")
            end
        end
        comment_id
    end

    def self.convert_to_array(rawdata)
		comments = Array.new
		rawdata.each do |data|
		  comment = Comment.new(data)
		  comments << comment
		end
		comments
	end

	def valid?
		return false if @content.nil? || @user_id.nil?
		true
	end

end