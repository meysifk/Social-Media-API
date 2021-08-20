require './db/mysql_connector'
require './models/hashtag'

class Post

	attr_reader :id, :content, :file, :user_id, :hashtags

	def initialize(params)
		@id = params["id"]
		@content = params["content"]
		@file = params["file"]
		@user_id = params["user_id"]
		@hashtags = params["content"] ? params["content"].scan(/#\w+/).flatten.to_set : nil
	end

    def save
        return false unless valid?

        client = create_db_client
        client.query("INSERT INTO Posts (content, file, user_id) VALUES ('#{content}', '#{file}', #{user_id})")
        rawData = client.query("SELECT LAST_INSERT_ID() AS id")
        post_id = Post.convert_to_array(rawData)[0].id

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
                client.query("INSERT INTO Post_Hashtags (hashtag_id, post_id) VALUES (#{id}, #{post_id})")
            end
        end
        post_id
    end

    def self.find_by_hashtag_id(id)
        client = create_db_client
        rawData = client.query("SELECT Posts.* FROM Post_Hashtags JOIN Posts on Post_Hashtags.post_id = Posts.id WHERE hashtag_id = #{id}")

		posts = convert_to_array(rawData)
        posts.map { |post| post.as_json }
	end

	def self.convert_to_array(rawdata)
		posts = Array.new
		rawdata.each do |data|
		  post = Post.new(data)
		  posts << post
		end
		posts
	end

	def as_json
        data = {
          id: id,
          content: content,
		  file: file,
          user_id: user_id,
          hashtags: hashtags.to_a
        }
        data
    end

    def valid?
		return false if @user_id.nil? || @content.nil?
        true
	end

end