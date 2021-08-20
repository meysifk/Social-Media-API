require './db/mysql_connector'

class Hashtag 
	attr_reader :id, :name

	def initialize(params)
		@id = params["id"]
    	@name = params["name"]? params["name"].downcase : nil
	end

	def save
		return false unless valid?

        client = create_db_client
        client.query("INSERT INTO Hashtags (name) VALUES ('#{name}')")
        rawData = client.query("SELECT id FROM Hashtags WHERE name = '#{name}'")

        Hashtag.convert_to_array(rawData)[0].id
	end

	def self.find_by_name(name)
		client = create_db_client
		rawData = client.query("SELECT id FROM Hashtags WHERE name = '#{name}'")
		return convert_to_array(rawData)[0] if rawData.any? nil
	end

	def self.find_by_id(id)
		client = create_db_client
		rawData = client.query("SELECT * FROM Hashtags WHERE id = #{id}")
		convert_to_array(rawData)[0]
	end

	def self.convert_to_array(rawData)
		hashtags = Array.new
		rawData.each do |data|
		  hashtag = Hashtag.new(data)
		  hashtags << hashtag
		end
		hashtags
	end

	def self.find_by_trend
		client = create_db_client
		time = Time.now - 60 * 60 * 24
		rawData = client.query("SELECT hashtag_id, SUM(number) total FROM ( SELECT hashtag_id, COUNT(hashtag_id) AS number FROM Post_Hashtags WHERE created_at > '#{time}' GROUP BY hashtag_id UNION ALL SELECT hashtag_id, COUNT(hashtag_id) AS number from Comment_Hashtags WHERE created_at > '#{time}' GROUP BY hashtag_id) h GROUP BY hashtag_id ORDER BY total DESC LIMIT 5")
		hashtags = Array.new
		for data in rawData do
			hashtag = Hashtag.find_by_id(data["hashtag_id"])
			hashtags << hashtag
		end
		hashtags.map { |hashtag| hashtag.as_json }
	end

	def as_json
		data = {
		  id: id,
		  name: name
		}
		data
	end

	def valid?
		return false if @name.nil? || exist?
        true
	end

	def exist?
		client = create_db_client
		exist = client.query("SELECT id FROM Hashtags WHERE name = '#{name}'")
		return true if exist.any?
		false
	end

end