require './models/post'
require './models/hashtag'
require 'securerandom'

class PostController 

	def self.add_post(params)
		unless params["file"].nil?
			filename = params["file"]["filename"]
            file = params["file"]["tempfile"]
            path = "./public/assets/#{SecureRandom.urlsafe_base64+filename}"
            File.open(path, 'wb') do |f|
                f.write(file.read)
            end
            params["file"] = path
        end
		post = Post.new(params)
		post.save
	end

	def self.get_by_hashtag_name(params)
		hashtag_name = params["hashtag_name"].downcase
        hashtag_id = Hashtag.find_by_name(hashtag_name)

        return Post.find_by_hashtag_id(hashtag_id.id) unless hashtag_id.nil?
	end
end